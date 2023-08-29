import PrimaryBt from '@/Components/FormsComponents/Buttons/PrimaryBt';
import Card from '@/Components/Card';
import DropDownList from '@/Components/FormsComponents/Inputs/DropDownList'
import Search from '@/Components/FormsComponents/Inputs/Search';
import Table from '@/Components/Table'

import { BsHouseDoor, BsGraphUp, BsFillBarChartFill, BsChartSquare, BsArrowRight } from 'react-icons/bs';
import Layout from '@/layout/Layout';
import CustomTable from '@/Components/CustomTable';
import Image from 'next/image';
import Link from 'next/link';
import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import api from '@/api/api';
import { countMatchingItems, tableFilters, tableSearch } from '@/api/filtersData';
import { toast } from 'react-toastify';
import { fetchLocations, fetchTypes } from '@/api/fetchData';
import { realEstateTypes, status } from '@/data/arrays';
import Select from 'react-select';
export default function Index() {
    const router = useRouter();
    const [realEstates, setRealEstates] = useState([]);
    const [searchResults, setSearchResults] = useState([]);

    const [typesOptions, setTypesOptions] = useState([]);
    const [locationsOptions, setLocationsOptions] = useState([]);
    const [statistics, setStatistics] = useState({
        totalRealEstates: '',
        availableRealEstates: '',
        realEstatesForSale: '',
        realEstatesForRent: ''
    });

    async function fetchRealEstates() {
        const authToken = localStorage.getItem('authToken');
        try {
            const realEstatesData = await api.get('realEstate/realty', authToken);
            setRealEstates(realEstatesData);
            const locations = await fetchLocations(authToken);
            const types = await fetchTypes(authToken);

            setTypesOptions(types);
            setLocationsOptions(locations);

            console.log(types, locations);
        } catch (error) {
            console.error('Error fetching real estates:', error);
        }
    }

    async function myStatistics() {
        const state = 'state';
        const secondType = 'secondType';
        setStatistics({
            ...statistics,
            totalRealEstates: realEstates.length,
            availableRealEstates: countMatchingItems('available', realEstates, state, true),
            realEstatesForSale: countMatchingItems('for sale', realEstates, secondType, true),
            realEstatesForRent: countMatchingItems('for rent', realEstates, secondType, true),
        })
    }
    useEffect(() => {


        fetchRealEstates();
        myStatistics();

    }, []);


    useEffect(() => {
        myStatistics();

    }, [realEstates]);
    const handleDropdownChange = async (e, itemId) => {
        const authToken = localStorage.getItem('authToken');
        try {
            const formDataForApi = new FormData();
            formDataForApi.append('state', e);
            const response = await api.post(`realEstate/${itemId}/edit`, formDataForApi, authToken);
            toast.success('تم تحديث حالة العقار بنجاح');
            const updatedRealEstates = realEstates.map((estate) => {
                if (estate.id === itemId) {
                    return { ...estate, attributes: { ...estate.attributes, state: e } };
                }
                return estate;
            });
            setRealEstates(updatedRealEstates);

        } catch (error) {
            console.error('Error updating realty data:', error);
            toast.error('حدث خطأ أثناء تحديث البيانات.');
        }
    };



    const columns = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'attributes',
            label: 'العقار',
            render: (item) => (
                <div className="flex items-center">
                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.attributes.photo.startsWith('storage') ? `http://127.0.0.1:8000/${item.attributes.photo}` : item.attributes.photo} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.attributes.name}</div>
                        <div className="font-normal text-gray-500">
                            {item.attributes.firstType.name}/
                            {item.attributes.secondType == 'for rent' ? 'للايجار' : 'للبيع'}
                        </div>
                    </div>
                </div>
            ),
        },
        {
            key: 'attributes', label: 'الموقع',
            render: (item) => (
                <div>{item.attributes.location.name}/{item.attributes.locationInfo}</div>
            ),
        },
        {
            key: 'attributes', label: 'السعر',
            render: (item) => (
                <div>{item.attributes.price}</div>
            ),
        },
        {
            key: 'attributes', label: 'الحالة',
            render: (item) => (
                <div className="flex items-center">
                    <select
                        className={item.attributes.state === "available" ? 'text-green-700' : 'text-red-700'}
                        value={item.attributes.state}
                        onChange={(e) => handleDropdownChange(e.target.value, item.id)}
                    >
                        {item.attributes.state === "available" ? (
                            <>
                                <option value="available" style={{ color: '#34D399' }} disabled>متاح</option>
                                <option value="Unavailable" style={{ color: '#EF4444' }}>غير متاح</option>
                            </>
                        ) : (
                            <>
                                <option value="Unavailable" style={{ color: '#EF4444' }} disabled>غير متاح</option>
                                <option value="available" style={{ color: '#34D399' }}>متاح</option>
                            </>
                        )}
                    </select>

                </div>
            ),
        },
    ];

    const data = [
        {
            number: 1,
            property: {
                name: "بيت للبيع في شارع القصر",
                imageSrc: "https://via.placeholder.com/640x480.png/00ee11?text=ullam",
                type: "بيت / بيع"
            },
            location: "عدن/ المنصورة / بلوك5",
            price: "$2999",
            status: "متاح"
        },
        {
            number: 2,
            property: {
                name: "بيت للبيع في شارع القصر",
                imageSrc: "https://via.placeholder.com/640x480.png/00ee11?text=ullam",
                type: "بيت / بيع"
            },
            location: "عدن/ المنصورة / بلوك5",
            price: "$2999",
            status: "متاح"
        }
    ];
    const handleSearch = (searchTerm) => {
        const searchedField = 'name'; // تعيين الحقل الذي ترغب في البحث فيه
        const filteredResults = tableSearch(searchTerm, realEstates, searchedField);
        setSearchResults(filteredResults);
    };

    const handleTypeSelect = (selectedType) => {
        const filterdField = 'firstType';
        const filteredResults = tableFilters(selectedType, realEstates, filterdField);

        setSearchResults(filteredResults);
        // هنا يمكنك تنفيذ الفلترة باستخدام النوع المحدد
    };

    const handleLocationSelect = (selectedType) => {
        const filterdField = 'location';
        const filteredResults = tableFilters(selectedType, realEstates, filterdField);

        setSearchResults(filteredResults);
        // هنا يمكنك تنفيذ الفلترة باستخدام الموقع المحدد
    };
    const handleStatusSelect = (selectedType) => {
        const filterdField = 'state';
        const filteredResults = tableFilters(selectedType, realEstates, filterdField, true);

        setSearchResults(filteredResults);
        // هنا يمكنك تنفيذ الفلترة باستخدام النوع المحدد
    };

    const handleSeconTypeSelect = (selectedType) => {
        const filterdField = 'secondType';
        const filteredResults = tableFilters(selectedType, realEstates, filterdField, true);

        setSearchResults(filteredResults);
        // هنا يمكنك تنفيذ الفلترة باستخدام الموقع المحدد
    };


    const handleEdit = (item) => {
        router.push(`RealEstate/Edit?id=${item.id}`)
    };
    const handleDelete = async (item) => {
        const authToken = localStorage.getItem('authToken');
        try {

            await api.deleteFunc(`realEstate/realty/${item.id}`, authToken);

            // إزالة العنصر المحذوف من القائمة
            const updatedRealEstates = realEstates.filter((estate) => estate.id !== item.id);
            setRealEstates(updatedRealEstates);
            toast.success('تم حذف العقار بنجاح');
        } catch (error) {
            toast.error('خطأ أثناء حذف العقار');
        }
    };

    return (

        <Layout>

            {/* // page container */}
            <div className="grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full" dir='rtl'>
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد العقارات"
                    value={statistics.totalRealEstates}
                    label="العدد الاجمالي"
                />
                <Card
                    id=""
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="العقارات المتاحة"
                    value={statistics.availableRealEstates}
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عقارات للبيع"
                    value={statistics.realEstatesForSale}
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عقارات للايجار"
                    value={statistics.realEstatesForRent}
                    label="العدد الاجمالي"
                />
            </div>
            <div className="flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black">


                {/* filter container */}

                <div className="flex items-center space-x-4 w-full p-4" dir='rtl'>
                    <div className="flex flex-col gap-y-4 w-full">
                        <div>
                            <p>خيارات البحث</p>
                        </div>
                        <div className='flex w-full '>
                            <DropDownList title="اختر نوع العقار" options={typesOptions} onSelect={handleTypeSelect} />
                            <DropDownList title="اختر موقع العقار" options={locationsOptions} onSelect={handleLocationSelect} />
                            <DropDownList title="اختر حالة العقار" options={realEstateTypes.data} onSelect={handleSeconTypeSelect} />
                            <DropDownList title="اختر الاتاحة" options={status.data} onSelect={handleStatusSelect} />
                            {/* <DropDownList />
                            <DropDownList />
                            <DropDownList /> */}
                        </div>
                        <div className='flex justify-between border-t-2 pt-5'>
                            <div>
                                {/* <PrimaryBt type="add" name="إضافة عقار جديد" onClick={() => { }} /> */}
                                <Link href="/RealEstate/New">

                                    <PrimaryBt type="add" name="إضافة عقار جديد" />

                                </Link>
                                <PrimaryBt type="export" name="تصدير" onClick={() => { }} />
                            </div>


                            <div>
                                <Search onSearch={handleSearch} />
                            </div>
                        </div>
                    </div>
                </div>
                {/* <Table /> */}

                <CustomTable
                    columns={columns}
                    data={searchResults.length > 0 ? searchResults : realEstates}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />
            </div>
        </Layout>
    )
}
