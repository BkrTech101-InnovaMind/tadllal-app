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

export default function Index() {
    const [orders, setOrders] = useState([]);
    const [endpoint, setEndpoint] = useState('orders');

    async function fetchOrders() {
        const authToken = localStorage.getItem('authToken');
        try {
            const ordersData = await api.get(endpoint, authToken);
            setOrders(ordersData.orders);
            console.log(ordersData);
        } catch (error) {
            console.error('Error fetching orders:', error);
        }
    }

    useEffect(() => {

        fetchOrders();

    }, [endpoint]);




    const handleOptionSelect = (selectedId) => {
        if (selectedId == 1) {
            setEndpoint('orders');
        } else if (selectedId == 2) {
            setEndpoint('servicesOrders');
        }
        // fetchTypes();
        console.log(`Selected ID: ${selectedId}`);
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
                "id": "1",
                "attributes": {
                    "name": "تحت المراجعة",
                }
            },
            {
                "id": "2",
                "attributes": {
                    "name": "تمت الموافقة علية",
                }
            },

        ]
    };

    const columns2 = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'prop',
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
            key: 'attributes',
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
            key: 'attributes', label: 'نص الطلب',
            render: (item) => (
                <div>{item.message}</div>
            ),
        },
        {
            key: 'attributes', label: 'حالة الطلب',
            render: (item) => (
                <div>{item.status == "Under Review" ? "تحت المراجعة" : "تمت الموافقة عليه"}</div>
            ),
        },
    ];

    const columns = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'attributes',
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
            key: 'attributes',
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
            key: 'attributes', label: 'نص الطلب',
            render: (item) => (
                <div>{item.message}</div>
            ),
        },
        {
            key: 'attributes', label: 'حالة الطلب',
            render: (item) => (
                <div>{item.status == "Under Review" ? "تحت المراجعة" : "تمت الموافقة عليه"}</div>
            ),
        },
    ];

    const handleSearch = (searchTerm) => {
        // يمكنك هنا تنفيذ البحث باستخدام searchTerm
        console.log('تم البحث عن:', searchTerm);
    };

    const handleEdit = (item) => {
        console.log(item.id);
    };

    const handleDelete = (item) => {
        console.log(item.id);
    };
    return (

        <Layout>

            {/* // page container */}
            <div className="grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full" dir='rtl'>
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد العقارات"
                    value="30"
                    label="العدد الاجمالي"
                />
                <Card
                    id=""
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد العقارات"
                    value="30"
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد العقارات"
                    value="30"
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد العقارات"
                    value="30"
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
                            {/* <DropDownList title="اختر حالة الطلب" options={array2.data} onSelect={handleOptionSelect} /> */}

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
                    data={orders}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />

                    : <CustomTable
                        columns={columns2}
                        data={orders}
                        onEdit={handleEdit}
                        onDelete={handleDelete} />

                }
            </div>
        </Layout>
    )
}
