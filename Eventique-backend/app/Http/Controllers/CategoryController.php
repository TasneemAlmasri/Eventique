<?php

namespace App\Http\Controllers;

use App\Http\Resources\CategoryRecource;
use App\Http\Resources\ServiceResource;
use App\Models\Category;
use App\Models\Favorite;
use App\Models\User;
use Illuminate\Http\Request;
use Stichoza\GoogleTranslate\GoogleTranslate;

class CategoryController extends Controller
{

    public function store(Request $request){
        $request->validate([
            'name' => ['required'],
        ]);
        $admin = auth()->user();
        $currentLocale = app()->getLocale();
        $targetLocale = ($currentLocale === 'en') ? 'ar' : 'en';

        $lang = new GoogleTranslate($currentLocale);
        $lang->setSource($currentLocale)->setTarget($targetLocale);

        $request->name = [
            $currentLocale => $request->name,
            $targetLocale => $lang->translate($request->name)
        ];
        if($admin) {
            Category::create([
                'name' => $request->name
            ]);
            return success();
        }
        return error('invaled Auth');
    }

    public function index(){
        return CategoryRecource::collection(Category::all());
    }

    public function show($id){
        $cat = Category::where('id', $id)->first();
        return success($cat->services);
    }

    public function deleteCategory ($id){
        $admin = auth()->user();
        $cat = Category::where('id', $id)->first();
        $cat->delete();
        return success();
    }
}
