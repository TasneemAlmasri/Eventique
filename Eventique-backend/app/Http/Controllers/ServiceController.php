<?php

namespace App\Http\Controllers;
use App\Http\Requests\Service\CreateServiceRequest;
use App\Http\Requests\Service\UpdateServiceActivationRequest;
use App\Http\Requests\Service\UpdateServiceRequest;
use App\Http\Resources\CategoryRecource;
use App\Http\Resources\CompanyResource;
use App\Http\Resources\ServiceResource;
use App\Models\Company;
use App\Models\Service;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Stichoza\GoogleTranslate\GoogleTranslate;


class ServiceController extends Controller
{
    public function index()
    {
//       return ServiceResource::collection(Service::paginate(10));
//        $services = Service::where('activation', 1)->get();
        $services =Service::with('reviews')->where('services.activation', 1)->get();

        // Calculate the average rating for each service
        $services->each(function ($service) {
            $service->average_rating = $service->reviews->avg('rate');
        });
        return ServiceResource::collection($services);

    }
    public function store(CreateServiceRequest $request)
    {

        $data = $request->validated();
        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';

        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);

        $data['name'] = [
            $currentLocale => $data['name'],
            $targetLocale => $lang->translate($data['name'])
        ];
        $data['description'] = [
            $currentLocale => $data['description'],
            $targetLocale => $lang->translate($data['description'])
        ];

//        $data['company_id'] = Auth::user()->id;
        $data['discounted_packages'] = $data['discounted_packages'] ?? 0;
        $data['activation'] = $data['activation'] ?? 1;

        $service = Service::create($data);
        foreach($data['images'] as $image){
            $service->images()->create(['url' => $image]);
        }
        return success(new ServiceResource($service));
    }
    public function show(Service $service)
    {
        return success(new ServiceResource($service));
    }
    /*public function update(UpdateServiceRequest $request, Service $service)
    {
        $data = $request->validated();
        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';

        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);
        if(isset($data['name']))
            $data['name'] = [
                $currentLocale => $data['name'],
                $targetLocale => $lang->translate($data['name'])
            ];

        if(isset($data['description']))
            $data['description'] = [
                $currentLocale => $data['description'],
                $targetLocale => $lang->translate($data['description'])
            ];

        if(isset($data['images'])){
            $service->images()->delete();
            foreach($data['images'] as $image)
                $service->images()->create(['url' => $image]);
        }

        return success(new ServiceResource($service));
    }*/

    public function update(UpdateServiceRequest $request, Service $service) 
    { 
        $data = $request->validated(); 
        $currentLocale = app()->getLocale(); 
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en'; 
 
        $lang = new GoogleTranslate($currentLocale); 
        $lang->setSource($currentLocale)->setTarget($targetLocale); 
        if(isset($data['name'])) 
            $data['name'] = [ 
                $currentLocale => $data['name'], 
                $targetLocale => $lang->translate($data['name']) 
            ]; 
 
        if(isset($data['description'])) 
            $data['description'] = [ 
                $currentLocale => $data['description'], 
                $targetLocale => $lang->translate($data['description']) 
            ]; 
 
        if(isset($data['images'])){ 
            $service->images()->delete(); 
            foreach($data['images'] as $image) 
                $service->images()->create(['url' => $image]); 
        } 
 $service->update($data);
        return success(new ServiceResource($service)); 
    }

    public function updateActivation(UpdateServiceActivationRequest $request,Service $service)
    {
        $data = $request->validated();
        if($service->company_id == auth()->user()->id)
        {
            $service->update($data);
            return success();
        }
        else{
            return error('Invalid service id');
        }
    }
    public function destroy(Service $service)
    {
        if($service->company_id == Auth::user()->id){
            $service->images()->delete();
            $service->delete();
            return success();
        }
        else{
            return error('Invalid service id');
        }

    }

    public function indexByCategory(Category $category)
    {
        $services = $category->services()->with('reviews')->where('services.activation', 1)->get();

        // Calculate the average rating for each service
        $services->each(function ($service) {
            $service->average_rating = $service->reviews->avg('rate');
        });
        return success(ServiceResource::collection($services));

    }
    public function indexCompanyServices(Company $company)
    {
        $services = $company->services;
        return success(ServiceResource::collection($services));
    }

    public function search(Request $request, $category)
    {
        $searchText = $request->input('search_text');
        $locale = app()->getLocale(); // Get the current locale (e.g., 'en' or 'ar')
        $services = collect();

        if ($category == 'all') {
            // Build query for services in all categories
            $serviceQuery = Service::query();
            $serviceQuery->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(name, '$.\"$locale\"'))"), 'LIKE', "%{$searchText}%");

            // Get services matching the search text
            $services = $serviceQuery->get();

            // Search for companies whose names contain the search text
            $companyQuery = Company::where('company_name', 'LIKE', '%' . $searchText . '%');
            $companies = $companyQuery->get();

            // Get services belonging to the companies whose names match the search text
            $companyServices = $companies->flatMap(function ($company) {
                return $company->services;
            });

            $services = $services->merge($companyServices);

        } else {
            // When a specific category ID is provided
            $category = Category::findOrFail($category);
            if ($category) {
                // Get services belonging to this category with search text
                $serviceQuery = $category->services();
                $serviceQuery->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(name, '$.\"$locale\"'))"), 'LIKE', "%{$searchText}%");
                $services = $serviceQuery->get();

                // Search for companies whose names contain the search text
                $companyQuery = $category->companies()
                    ->where('company_name', 'LIKE', '%' . $searchText . '%')
                    ->whereHas('services', function ($query) use ($category) {
                        $query->where('category_id', $category->id);
                    });
                $companies = $companyQuery->get();

                // Get services belonging to the companies within the specified category
                $companyServices = $companies->flatMap(function ($company) use ($category) {
                    return $company->services->where('category_id', $category->id);
                });

                // Merge the services found in both searches
                $services = $services->merge($companyServices);
            }
        }
        $result = [
            'services' => ServiceResource::collection($services)
        ];

        return response()->json($result);

    }
    public function searchCompany(Request $request)
    {
        $searchText = $request->input('search_text');
        $locale = app()->getLocale();
        $company = auth()->user();

        if (!$company) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        // Search for services that belong to the authenticated company
        $services = Service::where('company_id', $company->id)
            ->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(name, '$.\"$locale\"'))"), 'LIKE', "%{$searchText}%")
            ->get();

        // Search for categories that belong to the authenticated company
        $categories = $company->categories()
            ->where(DB::raw("JSON_UNQUOTE(JSON_EXTRACT(name, '$.\"$locale\"'))"), 'LIKE', "%{$searchText}%")
            ->get();

        // Prepare the result
        $result = [
            'services' => ServiceResource::collection($services),
            'categories' => CategoryRecource::collection($categories)
        ];

        return response()->json($result);
    }

}
