
import { FaHouse, FaMapLocationDot, FaUsers, FaBuilding, FaSitemap, FaInbox, FaToolbox } from 'react-icons/fa6';
import { FaSignOutAlt } from "react-icons/fa";
import Applogo from "@/images/applogo.png";
import Image from 'next/image';
import Link from 'next/link';
import React, { useState } from 'react';
import { useRouter } from 'next/router';
export default function Sidebar() {

    const [mainServicesOpen, setMainServicesOpen] = useState(false);
    const [subServicesOpen, setSubServicesOpen] = useState(false);
    const router = useRouter();
    const isActiveLink = (link) => {
        console.log(link);
        return router.pathname === link // Compare the router pathname with the link href
    }


    return (
        <div className="bg-minueBg w-1/4 h-screen text-minueColor p-4 sm:hidden text-right shadow-slate-50 ">
            <div className='flex flex-row-reverse items-center gap-5 mb-16'>
                <Image
                    src={Applogo}
                    alt="وصف الصورة"
                    width={50}
                    height={50}
                />
                <p className='font-bold text-4xl'>تدلل عقار</p>
            </div>
            <ul className="space-y-4 nav-item">
                <li>
                    <Link href="/"
                        className={`block ${isActiveLink('/') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}

                    >
                        {/* <AiFillHome /> */}
                        <FaHouse />
                        الرئيسية
                    </Link>
                </li>
                <li>
                    <Link href="/RealEstate"
                        className={`block ${isActiveLink('/RealEstate') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}


                    >
                        <FaBuilding />
                        العقارات
                    </Link>
                </li>
                <li>
                    <Link
                        href="/Locations"
                        className={`block ${isActiveLink('/Locations') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}

                    >
                        <FaMapLocationDot />
                        المواقع
                    </Link>
                </li>

                <li>
                    <Link href="/Types"
                        className={`block ${isActiveLink('/Types') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}
                    >
                        <FaSitemap />
                        انواع العقارات
                    </Link>
                </li>

                <li>
                    <Link href="/Services"
                        className={`block ${isActiveLink('/Services') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}
                    >
                        <FaToolbox />
                        خدمات انشائية وتوريدات
                    </Link>
                </li>


                <li>
                    <Link href="/Orders"
                        className={`block ${isActiveLink('/Orders') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}
                    >
                        <FaInbox />
                        الطلبات
                    </Link>
                </li>
                <li>
                    <Link href="/Users"
                        className={`block ${isActiveLink('/Users') ? 'text-white bg-gradient-to-br from-minueActiveGraideint-100 to-minueActiveGraideint-70' : 'hover:bg-munueHover'} px-2 py-1 rounded`}
                    >
                        <FaUsers />
                        المستخدمين
                    </Link>
                </li>
                <li>
                    <Link href="/Logout"
                        className='block hover:bg-munueHover px-2 py-1 rounded'
                    >
                        <FaSignOutAlt />
                        تسجيل خروج
                    </Link>
                </li>
            </ul>
        </div>
    );
}