<?php

namespace App\Mail;

use Illuminate\Mail\Mailable;

class ActivationCodeMail extends Mailable
{
    public $activationCode;

    public function __construct($activationCode)
    {
        $this->activationCode = $activationCode;
    }

    public function build()
    {
        return $this->view('emails.activation_code')->with([
            'activationCode' => $this->activationCode,
        ]);
    }
}