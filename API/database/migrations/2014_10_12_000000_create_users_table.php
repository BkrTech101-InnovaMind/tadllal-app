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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->enum('role', ['user', 'admin', 'marketer', 'company'])->default('user');
            $table->string('phone_number')->nullable();
            $table->string('avatar')->nullable();
            $table->boolean('activated')->default(false);
            $table->string('activation_code')->nullable();
            $table->string('reset_code')->nullable();
            // $table->unsignedBigInteger('registered_by')->nullable();
            $table->rememberToken();
            $table->timestamps();

            // $table->foreign('registered_by')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};