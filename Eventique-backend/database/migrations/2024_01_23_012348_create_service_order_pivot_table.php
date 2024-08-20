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
        Schema::create('service_order_pivot', function (Blueprint $table) {
            $table->id();
            $table->json('status')->nullable();
            $table->double('price');
            $table->integer('quantity');
            $table->foreignId('order_id')
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
        Schema::dropIfExists('service_order_pivot');
    }
};
