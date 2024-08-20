<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('customized_services', function (Blueprint $table) {
            $table->id();
//            $table->string('name');
            $table->double('price');
            $table->json('description');
            $table->json('status')->nullable();
            $table->foreignId('user_id')
                ->constrained('users')
                ->onUpdate('cascade')
                ->onDelete('cascade');
            $table->foreignId('order_id')->nullable()
                ->constrained('orders')
                ->onUpdate('cascade');
            $table->foreignId('service_id')
                ->constrained('services')
                ->onUpdate('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('custimized_services');
    }
};
