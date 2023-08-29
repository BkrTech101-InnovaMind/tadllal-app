import DropDownList from '@/Components/FormsComponents/Inputs/DropDownList';
import TextBox from '@/Components/FormsComponents/Inputs/TextBox';
import TextErea from '@/Components/FormsComponents/Inputs/TextErea';
import Layout from '@/layout/Layout';
import React, { useEffect, useState } from 'react';
import { toast } from 'react-toastify';
import { useRouter } from 'next/router';
import api from '@/api/api';
import Image from 'next/image';
import PrimaryBt from '@/Components/FormsComponents/Buttons/PrimaryBt';
import { fetchLocations, fetchTypes } from '@/api/fetchData';

export default function EditRealty() {
    const router = useRouter();
    const { id } = router.query;

    const [types, setTypes] = useState([]);
    const [locations, setLocations] = useState([]);
    const [formData, setFormData] = useState({
        name: '',
        price: 0,
        description: '',
        location: '',
        locationInfo: '',
        firstType: '',
        secondType: '',
        photo: null,
        images: [],
        state: '',
    });

    const [oldFormData, setOldFormData] = useState({
        name: '',
        price: 0,
        description: '',
        location: '',
        locationInfo: '',
        firstType: '',
        secondType: '',
        photo: null,
        images: [],
        state: '',
    });

    useEffect(() => {
        const authToken = localStorage.getItem('authToken');
        async function fetchData() {
            try {
                const typesData = await fetchTypes(authToken);
                const locationsData = await fetchLocations(authToken);
                setTypes(typesData);
                setLocations(locationsData);
            } catch (error) {
                console.error('Error fetching data first:', error);
            }
        }
        if (id) {
            fetchData();
            fetchRealtyData();
        }
    }, [id]);

    const fetchRealtyData = async () => {
        const authToken = localStorage.getItem('authToken');
        try {
            const realtyData = await api.get(`realEstate/realty/${id}`, authToken);
            setFormData({
                name: realtyData.attributes.name,
                price: realtyData.attributes.price,
                description: realtyData.attributes.description,
                location: realtyData.attributes.location,
                locationInfo: realtyData.attributes.locationInfo,
                firstType: realtyData.attributes.firstType,
                secondType: realtyData.attributes.secondType,
                photo: realtyData.attributes.photo,
                images: realtyData.attributes.images,
                state: realtyData.attributes.state,
            });
            setOldFormData({
                name: realtyData.attributes.name,
                price: realtyData.attributes.price,
                description: realtyData.attributes.description,
                location: realtyData.attributes.location,
                locationInfo: realtyData.attributes.locationInfo,
                firstType: realtyData.attributes.firstType,
                secondType: realtyData.attributes.secondType,
                photo: realtyData.attributes.photo,
                images: realtyData.attributes.images,
                state: realtyData.attributes.state,
            });
        } catch (error) {
            console.error('Error fetching realty data:', error);
            toast.error('فشل جلب البيانات');
        }
    };

    const handleUpdate = async () => {
        const authToken = localStorage.getItem('authToken');
        try {
            const formDataForApi = new FormData();

            // Check and append fields for update if they have changed
            if (formData.name && formData.name !== oldFormData.name) {
                formDataForApi.append('name', formData.name);
            }
            if (formData.price && formData.price !== oldFormData.price) {
                formDataForApi.append('price', parseInt(formData.price));
            }
            if (formData.description && formData.description !== oldFormData.description) {
                formDataForApi.append('description', formData.description);
            }
            if (formData.location && formData.location !== oldFormData.location) {
                formDataForApi.append('location', formData.location);
            }
            if (formData.locationInfo && formData.locationInfo !== oldFormData.locationInfo) {
                formDataForApi.append('locationInfo', formData.locationInfo);
            }
            if (formData.firstType && formData.firstType !== oldFormData.firstType) {
                formDataForApi.append('firstType', formData.firstType);
            }
            if (formData.secondType && formData.secondType !== oldFormData.secondType) {
                formDataForApi.append('secondType', formData.secondType);
            }
            if (formData.state && formData.state !== oldFormData.state) {
                formDataForApi.append('state', formData.state);
            }
            if (formData.photo) {
                if (formData.photo instanceof File && formData.photo.type.startsWith('image/')) {
                    formDataForApi.append('photo', formData.photo);
                }
            }
            if (formData.images) {
                formData.images.forEach((image) => {
                    if (image instanceof File && image.type.startsWith('image/')) {
                        formDataForApi.append('images[]', image);
                    }
                });
            }

            // Check if anything was changed
            if (
                formDataForApi.getAll('name').length === 0 &&
                formDataForApi.getAll('price').length === 0 &&
                formDataForApi.getAll('description').length === 0 &&
                formDataForApi.getAll('location').length === 0 &&
                formDataForApi.getAll('locationInfo').length === 0 &&
                formDataForApi.getAll('firstType').length === 0 &&
                formDataForApi.getAll('secondType').length === 0 &&
                formDataForApi.getAll('photo').length === 0 &&
                formDataForApi.getAll('images[]').length === 0 &&
                formDataForApi.getAll('state').length === 0
            ) {
                toast.warning('لم تقم بتعديل أي شيء');
                router.push('/RealEstate');
            } else {
                const response = await api.post(`realEstate/${id}/edit`, formDataForApi, authToken);
                toast.success('تم تحديث البيانات بنجاح');
                router.push('/RealEstate');
            }
        } catch (error) {
            console.error('Error updating realty data:', error);
            toast.error('حدث خطأ أثناء تحديث البيانات.');
        }
    };

    const array = {
        data: [
            { id: 'for rent', attributes: { name: 'ايجار' } },
            { id: 'for sale', attributes: { name: 'بيع' } },
        ],
    };

    const statuesArray = {
        data: [
            { id: 'available', attributes: { name: 'متاح' } },
            { id: 'Unavailable', attributes: { name: 'غير متاح' } },
        ],
    };

    return (
        <Layout>
            <div className="flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black">
                <div className="flex items-center space-x-4 w-full p-4" dir="rtl">
                    <form className="w-full">
                        <TextBox
                            type="text"
                            id="name"
                            label="اسم العقار"
                            name="name"
                            placeholder="ادخل اسم العقار"
                            value={formData.name}
                            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                            error={formData.name === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <TextBox
                            type="number"
                            id="price"
                            label="سعر العقار"
                            name="price"
                            placeholder="ادخل سعر العقار"
                            value={formData.price}
                            onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                            error={formData.price === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <TextErea
                            id="description"
                            label="وصف العقار"
                            name="description"
                            placeholder="ادخل وصف العقار"
                            value={formData.description}
                            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                            error={formData.description === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <DropDownList
                            title="موقع العقار"
                            options={locations}
                            selectedValue={formData.location}
                            onSelect={(e) => setFormData({ ...formData, location: e })}
                        />
                        <TextBox
                            type="text"
                            id="locationInfo"
                            label="عنوان العقار"
                            name="locationInfo"
                            placeholder="ادخل عنوان العقار"
                            value={formData.locationInfo}
                            onChange={(e) => setFormData({ ...formData, locationInfo: e.target.value })}
                            error={formData.locationInfo === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <DropDownList
                            title="نوع العقار"
                            options={types}
                            selectedValue={formData.firstType}
                            onSelect={(e) => setFormData({ ...formData, firstType: e })}
                        />
                        <DropDownList
                            title="طبيعة العقار"
                            options={array.data}
                            selectedValue={formData.secondType}
                            onSelect={(e) => setFormData({ ...formData, secondType: e })}
                        />
                        <div className="flex flex-col">
                            <label className="text-right mb-2">الصورة الرئيسية</label>
                            {formData.photo && (
                                <Image
                                    width={500}
                                    height={500}
                                    src={formData.photo}
                                    alt="صورة الخدمة"
                                    className="w-40 h-40 object-cover rounded"
                                />
                            )}
                        </div>
                        <div className="flex flex-col w-full">
                            <label className="text-right mb-2">بقية الصور</label>
                            {formData.images && formData.images.length > 0 && (
                                <div className="flex space-x-2 first-of-type:ml-4">
                                    {formData.images.map((image, index) => (
                                        <Image
                                            key={index}
                                            width={100}
                                            height={100}
                                            src={image}
                                            alt={`صورة ${index}`}
                                            className="w-20 h-20 object-cover rounded"
                                        />
                                    ))}
                                </div>
                            )}
                        </div>

                        <TextBox
                            type="file"
                            id="photo"
                            label="صورة العقار الرئيسية"
                            name="photo"
                            onChange={(e) =>
                                setFormData({ ...formData, photo: e.target.files[0] })
                            }
                            error={formData.photo === null ? 'هذا الحقل إجباري' : false}
                        />

                        <TextBox
                            type="file"
                            id="images"
                            label=" صور العقار "
                            name="images"
                            placeholder="ادخل صور العقار"
                            onChange={(e) =>
                                setFormData({
                                    ...formData,
                                    images: Array.from(e.target.files),
                                })
                            }
                            error={formData.images.length === 0 ? 'هذا الحقل إجباري' : false}
                            multiple
                        />

                        <DropDownList
                            title="حالة العقار"
                            options={statuesArray.data}
                            selectedValue={formData.state}
                            onSelect={(e) => setFormData({ ...formData, state: e })}
                        />
                        {/* Add image editing fields here */}
                        <PrimaryBt
                            type="button"
                            name="تحديث"
                            onClick={handleUpdate}
                        />
                    </form>
                </div>
            </div>
        </Layout>
    );
}
