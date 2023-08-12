composer install
cp .env.example .env
php artisan migrate
php artisan db:seed
composer require illuminate/filesystem
php artisan storage:link

php artisan serve
