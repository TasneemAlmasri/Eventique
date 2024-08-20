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
        Schema::create('event_service', function (Blueprint $table) {
            $table->id();
            $table->foreignId('event_id')
            ->constrained('events')
            ->onDelete('cascade')
            ->onUpdate('cascade');
            $table->foreignId('service_id')
            ->constrained('services')
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
        Schema::dropIfExists('event_service');
    }
};
