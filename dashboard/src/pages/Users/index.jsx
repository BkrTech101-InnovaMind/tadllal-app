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
import avatar from "@/images/user.png"
import axios from 'axios';
const API_URL = "http://127.0.0.1:8000/api/dashboard/users/";

export default function Index() {
    const router = useRouter();
    const [users, setUsers] = useState([]);
    async function fetchUsers() {

        try {
            const response = await axios.get('users', {
                baseURL: API_URL,
                headers: {
                    "Content-Type": `application/vnd.api+json`,
                    "Accept": `application/vnd.api+json`,
                    "Authorization": `Bearer ${localStorage.getItem('authToken')}`,
                },
            });

            const usersData = response.data.data;
            setUsers(usersData);
            console.log(usersData);

        } catch (error) {
            alert("error");
            console.error("Error fetching Users:", error);
        }
    }


    useEffect(() => {
        // قم بإجراء طلب HTTP لجلب العقارات


        // استدعاء الدالة لجلب البيانات
        fetchUsers();
    }, []);


    const getUserType = (userType) => {
        switch (userType) {
            case 'user':
                return 'مستخدم';
            case 'marketer':
                return 'مسوق';
            case 'company':
                return 'شركة';
            case 'admin':
                return 'مدير';
            default:
                return 'غير معروف';
        }
    }

    const handleOptionSelect = (selectedId) => {
        console.log(`Selected ID: ${selectedId}`);
    };
    const array = {
        "data": [
            {
                "id": "1",
                "attributes": {
                    "name": "rerum",
                    "image": "https://via.placeholder.com/640x480.png/0044ee?text=neque"
                }
            },
            {
                "id": "2",
                "attributes": {
                    "name": "porro",
                    "image": "https://via.placeholder.com/640x480.png/007700?text=dolorum"
                }
            },
            {
                "id": "3",
                "attributes": {
                    "name": "dolorum",
                    "image": "https://via.placeholder.com/640x480.png/0099cc?text=cupiditate"
                }
            },
            {
                "id": "4",
                "attributes": {
                    "name": "voluptatem",
                    "image": "https://via.placeholder.com/640x480.png/0033cc?text=cumque"
                }
            },
            {
                "id": "6",
                "attributes": {
                    "name": "perferendis",
                    "image": "https://via.placeholder.com/640x480.png/0033bb?text=ipsum"
                }
            },
            {
                "id": "7",
                "attributes": {
                    "name": "incidunt",
                    "image": "https://via.placeholder.com/640x480.png/00bbaa?text=nobis"
                }
            },
            {
                "id": "8",
                "attributes": {
                    "name": "et",
                    "image": "https://via.placeholder.com/640x480.png/00cc11?text=provident"
                }
            },
            {
                "id": "9",
                "attributes": {
                    "name": "vel",
                    "image": "https://via.placeholder.com/640x480.png/00aaff?text=laudantium"
                }
            },
            {
                "id": "10",
                "attributes": {
                    "name": "delectus",
                    "image": "https://via.placeholder.com/640x480.png/00aacc?text=omnis"
                }
            },
            {
                "id": "11",
                "attributes": {
                    "name": "maxime",
                    "image": "https://via.placeholder.com/640x480.png/005522?text=consequatur"
                }
            },
            {
                "id": "12",
                "attributes": {
                    "name": "voluptates",
                    "image": "https://via.placeholder.com/640x480.png/00cc66?text=velit"
                }
            },
            {
                "id": "13",
                "attributes": {
                    "name": "sequi",
                    "image": "https://via.placeholder.com/640x480.png/004477?text=in"
                }
            },
            {
                "id": "14",
                "attributes": {
                    "name": "doloremque",
                    "image": "https://via.placeholder.com/640x480.png/00ee11?text=ullam"
                }
            },
        ]
    };

    const columns = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'attributes',
            label: 'المستخدم',
            render: (item) => (
                <div className="flex items-center">
                    {!item.attributes.avatar ?
                        <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={avatar} alt="Jese image" /> :
                        <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.attributes.avatar} alt="Jese image" />}
                    {/* <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.attributes.avatar} alt="Jese image" /> */}
                    <div className="pl-3">
                        <div className="text-base font-semibold">{!item.attributes.name ? "لايوجد" : item.attributes.name}</div>
                        <div className="font-normal text-gray-500">{item.attributes.email}</div>
                    </div>
                </div>
            ),
        },
        {
            key: 'attributes', label: 'نوع المستخدم',
            render: (item) => (
                <div>{getUserType(item.attributes.role)}</div>
            ),
        },
        {
            key: 'attributes', label: 'رقم الهاتف',
            render: (item) => (
                <div>{!item.attributes.phone ? "لايوجد" : item.attributes.phone}</div>
            ),
        },
        {
            key: 'attributes', label: 'الحالة',
            render: (item) => (
                <div>{item.attributes.activated ? "مفعل" : "غير مفعل"}</div>
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
        // يمكنك هنا تنفيذ البحث باستخدام searchTerm
        console.log('تم البحث عن:', searchTerm);
    };

    const handleEdit = (item) => {
        router.push(`Users/Edit?id=${item.id}`);
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
                            <DropDownList title="اختر نوع العقار" options={array.data} onSelect={handleOptionSelect} />
                            <DropDownList title="اختر موقع العقار" options={array.data} onSelect={handleOptionSelect} />
                            <DropDownList title="اختر حالة العقار" options={array.data} onSelect={handleOptionSelect} />
                            <DropDownList title="اختر الاتاحة" options={array.data} onSelect={handleOptionSelect} />
                            {/* <DropDownList />
                            <DropDownList />
                            <DropDownList /> */}
                        </div>
                        <div className='flex justify-between border-t-2 pt-5'>
                            <div>
                                {/* <PrimaryBt type="add" name="إضافة عقار جديد" onClick={() => { }} /> */}
                                <Link href="/Users/New">

                                    <PrimaryBt type="add" name="إضافة مستخدم جديد" />

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
                    data={users}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />
            </div>
        </Layout>
    )
}
