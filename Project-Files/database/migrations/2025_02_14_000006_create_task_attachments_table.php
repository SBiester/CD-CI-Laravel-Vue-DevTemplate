<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTaskAttachmentsTable extends Migration {
    public function up()
{
    Schema::create('task_attachments', function (Blueprint $table) {
        $table->id();
        $table->foreignId('task_id')->constrained('tasks')->onDelete('cascade');
        $table->string('file_path');
        $table->string('file_name');
        $table->timestamps();
    });
}

};
