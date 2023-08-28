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
import api from '@/api/api';
import { searchOrders, tableFilters, tableSearch } from '@/api/filtersData';

export default function Index() {
    const [orders, setOrders] = useState([]);
    const [sevices, setSevices] = useState([]);
    const [data, setData] = useState([]);

    const [endpoint, setEndpoint] = useState('orders');
    const [searchResults, setSearchResults] = useState([]);

    async function fetchOrders() {
        const authToken = localStorage.getItem('authToken');
        try {

            const ordersData = await api.get(endpoint, authToken);
            setOrders(ordersData.orders);

            const servicesOrdersData = await api.get('servicesOrders', authToken);
            setSevices(servicesOrdersData.orders);

            console.log(ordersData);
        } catch (error) {
            console.error('Error fetching orders:', error);
        }
    }

    useEffect(() => {

        fetchOrders();
    }, []);

    useEffect(() => {

        setData(orders);
    }, [orders]);



    const handleOptionSelect = (selectedId) => {
        if (selectedId == 1) {
            setEndpoint('orders');
            setSearchResults("");
            setData(orders);
        } else if (selectedId == 2) {
            setEndpoint('servicesOrders');
            setSearchResults("");
            setData(sevices);
        }

        console.log(`Selected ID: ${selectedId}`);
    };

    const handleStatusSelect = (selectedId) => {
        const filteredResults = data.filter((item) =>
            item.status === selectedId

        );
        setSearchResults(filteredResults);
    };

    const getApprovedServicesCount = () => {
        const approvedServicesCount = sevices.filter(item => item.status === 'Approved').length;
        return approvedServicesCount;
    };

    // حساب عدد الطلبات بحالة "Under Review" في جدول الخدمات
    const getUnderReviewServicesCount = () => {
        const underReviewServicesCount = sevices.filter(item => item.status === 'Under Review').length;
        return underReviewServicesCount;
    };

    // حساب عدد الطلبات بحالة "Approved" في جدول العقارات
    const getApprovedOrdersCount = () => {
        const approvedOrdersCount = orders.filter(item => item.status === 'Approved').length;
        return approvedOrdersCount;
    };

    // حساب عدد الطلبات بحالة "Under Review" في جدول العقارات
    const getUnderReviewOrdersCount = () => {
        const underReviewOrdersCount = orders.filter(item => item.status === 'Under Review').length;
        return underReviewOrdersCount;
    };

    const handleSearch = (searchTerm) => {

        const filteredResults = searchOrders(searchTerm, data, endpoint);
        setSearchResults(filteredResults);
        console.log('تم البحث عن:', searchTerm);
    };

    const handleEdit = (item) => {
        console.log(item.id);
    };

    const handleDelete = (item) => {
        console.log(item.id);
    };


    const array = {
        "data": [
            {
                "id": "1",
                "attributes": {
                    "name": "طلبات العقارات",
                }
            },
            {
                "id": "2",
                "attributes": {
                    "name": "طلبات الخدمات",
                }
            },

        ]
    };

    const array2 = {
        "data": [
            {
                "id": "Under Review",
                "attributes": {
                    "name": "تحت المراجعة",
                }
            },
            {
                "id": "Approved",
                "attributes": {
                    "name": "تمت الموافقة علية",
                }
            },

        ]
    };



    const columns = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'realEstate',
            label: 'العقار',
            render: (item) => (
                <div className="flex items-center">
                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.real_estate.attributes.photo} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.real_estate.attributes.name}</div>
                        <div className="font-normal text-gray-500">{item.real_estate.attributes.firstType.name}/{item.real_estate.attributes.secondType}</div>
                    </div>
                </div>
            ),
        },
        {
            key: 'user',
            label: 'مقدم الطلب',
            render: (item) => (
                <div className="flex items-center">
                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.user.userImage} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.user.name}</div>
                        <div className="font-normal text-gray-500">{item.user.email}</div>
                        <div className="font-normal text-gray-500">{item.user.phoneNumber}</div>
                    </div>
                </div>
            ),
        },
        {
            key: 'message', label: 'نص الطلب',
            render: (item) => (
                <div>{item.message}</div>
            ),
        },
        {
            key: 'status', label: 'حالة الطلب',
            render: (item) => (
                <div>{item.status == "Under Review" ? "تحت المراجعة" : "تمت الموافقة عليه"}</div>
            ),
        },
    ];


    const columns2 = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'service',
            label: 'الخدمة',
            render: (item) => (
                <div className="flex items-center">
                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.sub_construction_service.attributes.image} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.sub_construction_service.attributes.name}</div>
                        <div className="font-normal text-gray-500">تابعة للخدمة : {item.sub_construction_service.attributes.construction}</div>
                    </div>
                </div>
            ),
        },
        {
            key: 'user',
            label: 'مقدم الطلب',
            render: (item) => (
                <div className="flex items-center">
                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.user.userImage} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.user.name}</div>
                        <div className="font-normal text-gray-500">{item.user.email}</div>
                        <div className="font-normal text-gray-500">{item.user.phoneNumber}</div>
                    </div>
                </div>
            ),
        },
        {
            key: 'message', label: 'نص الطلب',
            render: (item) => (
                <div>{item.message}</div>
            ),
        },
        {
            key: 'status', label: 'حالة الطلب',
            render: (item) => (
                <div>{item.status == "Under Review" ? "تحت المراجعة" : "تمت الموافقة عليه"}</div>
            ),
        },
    ];


    return (

        <Layout>

            {/* // page container */}
            <div className="grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full" dir='rtl'>
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="طلبات العقارات"
                    value={orders.length}
                    label="العدد الاجمالي"
                />
                <Card
                    id=""
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="طلبات الخدمات"
                    value={sevices.length}
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="الموافق عليها"
                    value={getApprovedServicesCount() + getApprovedOrdersCount()}
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="تحت المراجعه"
                    value={getUnderReviewServicesCount() + getUnderReviewOrdersCount()}
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
                            <DropDownList title="اختر نوع الطلب" options={array.data} onSelect={handleOptionSelect} />
                            <DropDownList title="اختر حالة الطلب" options={array2.data} onSelect={handleStatusSelect} />

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

                {endpoint == 'orders' ? <CustomTable
                    columns={columns}
                    data={searchResults.length > 0 ? searchResults : data}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />

                    : <CustomTable
                        data={searchResults.length > 0 ? searchResults : data}
                        columns={columns2}
                        onEdit={handleEdit}
                        onDelete={handleDelete} />

                }
            </div>
        </Layout>
    )
}
