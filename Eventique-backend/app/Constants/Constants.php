<?php 
namespace App\Constants; 
 
 class Constants{ 
    const SERVICE_ORDER_STATUSES = [ 
        'REJECTED' => [ 
            'ar' => 'مرفوض', 
            'en' => 'rejected' 
        ], 
        'PENDING' => [ 
            'ar' => 'معلق', 
            'en' => 'pending' 
        ], 
        'ACCEPTED' => [ 
            'ar' => 'مقبول', 
            'en' => 'accepted' 
        ] 
    ]; 
 
} 