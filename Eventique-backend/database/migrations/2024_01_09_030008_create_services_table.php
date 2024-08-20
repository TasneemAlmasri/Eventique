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
        Schema::create('services', function (Blueprint $table) {
            $table->id();
            $table->json('name');
            $table->double('price');
            $table->json('description');
            $table->boolean('discounted_packages')->default(0);
            $table->boolean('activation')->default(1);
            $table->foreignId('category_id')
            ->constrained('categories')
            ->onUpdate('cascade');
             $table->foreignId('company_id')
             ->constrained('companies')
             ->onDelete('cascade')
             ->onUpdate('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('services');
    }
};
