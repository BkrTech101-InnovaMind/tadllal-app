<!-- <!DOCTYPE html>
<html>
<head>
    <title></title>

</head>
<body>
    Welcome New User your account created successfully & Activation code is :
    <h1> {{$codee}}</h1> 
  
</body>
</html> -->

<!DOCTYPE html>
<html lang="ar">
<head>
    <title>التحقق من البريد الالكتروني</title>
    <style>
        body {
    margin: 0;
    padding: 0;
    background-color: #eda410;
}
.a {
    padding-left: 4%;
    padding-top: 2%;
}
.b {
    padding-left: 40%;
    padding-top: 1%;
}
.c {
    padding-left: 39%;
    /* padding-top: 10%; */
}
.d {
    margin-left: -2%;
}
.e {
    padding-left: 84px;
    padding-top: 2%;
    margin-bottom: -1%;
}
.f {
    padding-left: 9%;
    color: #194706;
}
.i {
    /* background-color: #eda410; */
    background-color: black;
    padding: 500px;
    padding-right: 500px;
    padding-bottom: 20px;
    padding-top: 80px;
}
.g {
    color: #194706;
    margin-left: -4%;
}

    </style>
  </head>
  <body>
    <div class="a">
      <img
        class="i"
        src="logo.png"
        alt="شعار تدلل"
        width="200"
        height="200"
      />
      <h2 class="b">مرحبا ابوبكر صديق</h2>
    </div>
    <div class="c">
      <p>:مرحبا بك في تطبيقنا. رمز التحقق الخاص بك هو</p>
      <h1>{{$codee}}</h1>
      <p class="d">إذا لم بادخال الكود خلال 24 ساعة ، فسيتم حذف حسابك</p>
      <p class="e">&nbsp; فريق تطبيق تدلل</p>
      <p class="g">هذة الرسالة خاصة الرجاء عدم اعادة توجيهها لاي شخص اخر</p>
    </div>
  </body>
</html>