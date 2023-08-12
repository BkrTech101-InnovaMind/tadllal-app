<!DOCTYPE html>
<html>
<head>
    <title>Account Activation</title>
</head>
<body>
    <h1>Hello {{ $user->name }}</h1>
    <p>
        Thank you for creating an account with our application. To activate your account, please click on the following link:
    </p>
    <a href="{{ url('activate/' . $user->activation_code) }}">Activate Account</a>
    <p>
        If you do not click on the link within 24 hours, your account will be deleted.
    </p>
    <p>
        Thank you,
        <br>
        The team
    </p>
</body>
</html>
