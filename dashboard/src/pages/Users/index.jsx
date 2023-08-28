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

import api from '@/api/api';
import { toast } from 'react-toastify';
import { usersFiltersArray } from '@/data/arrays';
import { countMatchingItems, tableFilters, tableSearch } from '@/api/filtersData';
import { useLoading } from '@/Context API/LoadingContext';


export default function Index() {
    const router = useRouter();
    const [users, setUsers] = useState([]);
    const [searchResults, setSearchResults] = useState([]);
    const [statistics, setStatistics] = useState({
        totalUsers: '',
        totalMarketers: '',
        totalCompany: '',
        usersNotActive: ''
    });
    const { isLoading, setIsLoading } = useLoading();
    async function fetchUsers() {
        const authToken = localStorage.getItem('authToken');

        try {
            const usersData = await api.get('users/users/', authToken);
            setUsers(usersData);

        } catch (error) {
            console.error('Error fetching Users:', error);
        }
    }
    async function myStatistics() {
        const type = 'role';
        const status = 'activated';
        setStatistics({
            ...statistics,
            totalUsers: users.length,
            totalCompany: countMatchingItems('company', users, type, true),
            totalMarketers: countMatchingItems('marketer', users, type, true),
            usersNotActive: countMatchingItems('no', users, status, true),
        })
    }

    useEffect(() => {
        fetchUsers();

    }, []);
    useEffect(() => {

        myStatistics();
    }, [users]);

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
    const handleUserTypeSelect = (selectedType) => {
        const filterdField = 'role';
        const filteredResults = tableFilters(selectedType, users, filterdField, true);

        setSearchResults(filteredResults);
        // هنا يمكنك تنفيذ الفلترة باستخدام النوع المحدد
    };

    const handleUserStatusSelect = (selectedType) => {
        const filterdField = 'activated';
        const filteredResults = tableFilters(selectedType, users, filterdField, true);

        setSearchResults(filteredResults);
        // هنا يمكنك تنفيذ الفلترة باستخدام النوع المحدد
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
                <div className={item.attributes.activated == 'yes' ? 'text-green-600' : 'text-red-700'}>{item.attributes.activated == 'yes' ? "مفعل" : "غير مفعل"}</div>
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
        const searchedField = 'name';
        const filteredResults = tableSearch(searchTerm, users, searchedField);
        setSearchResults(filteredResults);
    };

    const handleEdit = (item) => {
        router.push(`Users/Edit?id=${item.id}`);
    };

    const handleDelete = async (item) => {
        const authToken = localStorage.getItem('authToken');
        try {
            await api.deleteFunc(`users/users/${item.id}`, authToken);

            const updatedUsers = users.filter((user) => user.id !== item.id);
            setUsers(updatedUsers);
            toast.success('تم حذف المستخدم بنجاح');
        } catch (error) {
            console.log(error);
            toast.error('خطأ أثناء حذف المستخدم');
        }
    };
    return (

        <Layout>

            {/* // page container */}
            <div className="grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full" dir='rtl'>
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد المستخدمين"
                    value={statistics.totalUsers}
                    label="العدد الاجمالي"
                />
                <Card
                    id=""
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد الشركات"
                    value={statistics.totalCompany}
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد المسوقين"
                    value={statistics.totalMarketers}
                    label="العدد الاجمالي"
                />
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد المستخدمين المفعلين"
                    value={statistics.usersNotActive}
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
                            <DropDownList title="اختر نوع المستخدم" options={usersFiltersArray.userType} onSelect={handleUserTypeSelect} />
                            <DropDownList title="اختر حالة المستخدم" options={usersFiltersArray.userStatues} onSelect={handleUserStatusSelect} />
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
                    data={searchResults.length > 0 ? searchResults : users}
                    onEdit={handleEdit}
                    onDelete={handleDelete}
                    extraButtonType='view'
                    myFunction={handleDelete} />
            </div>
        </Layout>
    )
}
