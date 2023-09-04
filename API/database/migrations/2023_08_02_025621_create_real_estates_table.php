<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('real_estates', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description');
            $table->integer('price');
            $table->unsignedBigInteger('location_id');
            $table->string('image')->nullable();
            $table->unsignedBigInteger('type1_id');
            $table->string('location_info');
            $table->enum('state', ['available', 'Unavailable'])->default('available');
            $table->enum('type2', ['for sale', 'for rent']);
            $table->string('rooms')->nullable(); // عدد الغرف
            $table->string('floors')->nullable(); // عدد الادوار
            $table->string('vision')->nullable(); // البصيرة
            $table->string('baptism')->nullable(); // التعميد
            $table->string('area'); //المساحة
            $table->timestamps();

            $table->foreign('location_id')->references('id')->on('rlocations');
            $table->foreign('type1_id')->references('id')->on('rtypes');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('real_estates');
    }
};