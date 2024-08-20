<?php  

namespace Database\Seeders;  

use App\Models\Category;  
use Illuminate\Database\Seeder;  

class CategorySeeder extends Seeder  
{  
    /**  
     * Run the database seeds.  
     */  
    public function run(): void  
    {  
        Category::create([  
            'id' => 1,  
            'name' => [  
                'en' => 'venue',  
                'ar' => 'صالات'  
            ]  
        ]);  

        Category::create([  
            'id' => 2,  
            'name' => [  
                'en' => 'catering',  
                'ar' => 'خدمات الطعام'  
            ]  
        ]);  

        Category::create([  
            'id' => 3,  
            'name' => [  
                'en' => 'flowers',  
                'ar' => 'الزهور'  
            ]  
        ]);  

        Category::create([  
            'id' => 4,  
            'name' => [  
                'en' => 'cake',  
                'ar' => 'الكيك'  
            ]  
        ]);  

        Category::create([  
            'id' => 5,  
            'name' => [  
                'en' => 'accessories',  
                'ar' => 'الإكسسوارات'  
            ]  
        ]);  

        Category::create([  
            'id' => 6,  
            'name' => [  
                'en' => 'photography',  
                'ar' => 'التصوير'  
            ]  
        ]);  

        Category::create([  
            'id' => 7,  
            'name' => [  
                'en' => 'entertainment',  
                'ar' => 'الترفيه'  
            ]  
        ]);  

        Category::create([  
            'id' => 8,  
            'name' => [  
                'en' => 'decoration',  
                'ar' => 'الديكور'  
            ]  
        ]);  

        Category::create([  
            'id' => 9,  
            'name' => [  
                'en' => 'transportation',  
                'ar' => 'النقل'  
            ]  
        ]);  

    }  
}