<?php

namespace App\Http\Controllers;

use App\Http\Requests\Package\CreatePackageRequest;
use App\Http\Requests\Package\UpdatePackageRequest;
use App\Http\Resources\PackageResource;
use App\Http\Resources\ServiceResource;
use App\Models\Package;
use App\Models\Service;
use Illuminate\Http\Request;

class PackageController extends Controller
{
    public function index()
    {
        return success(PackageResource::collection(Package::all()));
    }
    public function indexPackagableServices()
    {
        $services = Service::where('discounted_packages', 1)->get();
        return success(ServiceResource::collection($services));
    }
    public function store(CreatePackageRequest $request)
    {
        $data = $request->validated();
        $serviceIds = collect($data['services'])->pluck('id')->toArray();
        $services = Service::whereIn('id', $serviceIds)->get();
        $data['old_price'] = $services->sum('price');
        $data['new_price'] = $services->sum(function($service) {
            return $service->price * 0.995; // 0.995 represents 99.5% of the original price
        });
        $package = Package::create($data);
        $package->images()->create(['url' => $data['image']]);
        $package->services()->attach($serviceIds);
        return success(PackageResource::make($package));

    }
    public function show(Package $package)
    {
        return success(PackageResource::make($package));
    }
    public function update(UpdatePackageRequest $request, Package $package)
    {
        $data = $request->validated();
        if(isset($data['image'])){
            $package->images()->first()->update(['url' => $data['image']]);
        }
        if(isset($data['services'])){
            $serviceIds = collect($data['services'])->pluck('id')->toArray();
            $package->services()->attach($serviceIds);
        }
        if(isset($data['delete_services'])){
            $package->services()->detach($data['delete_services']);
        }
        $data['old_price'] = $package->services->sum('price');
        $data['new_price'] = $package->services->sum(function($service) {
            return $service->price * 0.995; // 0.995 represents 99.5% of the original price
        });
        $package->update($data);
        return success(PackageResource::make($package));
    }

    public function destroy(Package $package)
    {
        $package->images()->delete();
        $package->deleteOrFail();
        return success();
    }
}
