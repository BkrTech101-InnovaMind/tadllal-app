import React, { useState } from 'react';
import Avatar from "@/images/avatar2.png";
import Image from 'next/image';
import { FaAngleDown } from "react-icons/fa";
const Nav = () => {
    const [dropdownOpen, setDropdownOpen] = useState(false);

    const toggleDropdown = () => {
        setDropdownOpen(!dropdownOpen);
    };

    return (
        <div className="bg-minueBg h-16 flex items-center  justify-between px-4 rounded-md shadow-slate-400 mb-4">
            <div className="flex items-center">
                <div className="relative flex flex-row items-center">
                    <div className='flex flex-row- items-center'>
                        <Image
                            src={Avatar}
                            alt="Admin"
                            className="w-10 h-10 rounded-full cursor-pointer"
                        />
                        <p className='text-minueColor'>Admin</p>
                    </div>

                    <button
                        onClick={toggleDropdown}
                        className=" focus:outline-none"
                    >
                        <FaAngleDown className='text-minueColor' />
                    </button>
                    {dropdownOpen && (
                        <div className="absolute top-14 left-1 right-5 mt-1 w-40 bg-white border border-gray-300 rounded shadow">
                            <ul className="py-1">
                                <li>
                                    <a
                                        href="#"
                                        className="block px-4 py-2 hover:bg-gray-100 text-gray-800"
                                    >
                                        تسجيل الخروج
                                    </a>
                                </li>
                                {/* يمكنك إضافة المزيد من الخيارات هنا */}
                            </ul>
                        </div>
                    )}
                </div>
            </div>
            <h1 className="text-minueColor text-lg font-semibold">لوحة التحكم</h1>
        </div>
    );
};

export default Nav;