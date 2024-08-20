<?php

namespace Database\Seeders;

use App\Models\EventType;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class EventTypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        EventType::create([
            'id' => 1,
            'name' => [
                'en' => 'birthday',
                'ar' => 'اعياد ميلاد'
            ]
        ]);
        EventType::create([
            'id' => 2,
            'name' => [
                'en' => 'wedding',
                'ar' => 'اعراس'
            ]
        ]);
        EventType::create([
            'id' => 3,
            'name' => [
                'en' => 'engagement',
                'ar' => 'خطبة'
            ]
        ]);
        EventType::create([
            'id' => 4,
            'name' => [
                'en' => 'holiday',
                'ar' => 'اجازة'
            ]
        ]);

    }
}
