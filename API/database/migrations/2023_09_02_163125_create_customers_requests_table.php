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
        Schema::create('customers_requests', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id'); // ايدي المستخدم
            $table->unsignedBigInteger('customer_id'); // ايدي العميل
            $table->unsignedBigInteger('location_id'); // ايدي الموقع
            $table->unsignedBigInteger('type_id'); // ايدي النوع
            $table->string('property'); // العقار
            $table->integer('budget_from'); // الميزانية من
            $table->integer('budget_to'); // الميزانية إلى
            $table->enum('currency', ['SAR', 'YER', 'USD']); // العملة
            $table->text('other_details')->nullable(); // تفاصيل أخرى
            $table->enum('request_status', ['pending', 'review', 'communicated'])->default('pending'); // حالة الطلب
            $table->enum('communication_status', ['pending', 'successful', 'unsuccessful'])->default('pending'); // حالة التواصل مع العميل
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('customer_id')->references('id')->on('customers')->onDelete('cascade');
            $table->foreign('location_id')->references('id')->on('rlocations');
            $table->foreign('type_id')->references('id')->on('rtypes');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('customers_requests');
    }
};