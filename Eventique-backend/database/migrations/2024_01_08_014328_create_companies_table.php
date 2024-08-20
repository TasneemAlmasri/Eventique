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
        Schema::create('companies', function (Blueprint $table) {
            $table->id();
            $table->string('first_name');
            $table->string('last_name');
            $table->string('email');
            $table->string('password');
            $table->integer('phone_number');
            $table->string('company_name');
            $table->integer('registration_number');
            $table->json('location');
            $table->json('city');
            $table->json('country');
            $table->json('description');
            $table->boolean('accept_privacy')->default(0);
            $table->boolean('accessibility')->default(0);
            $table->longText('fcm_token')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('companies');
    }
};
