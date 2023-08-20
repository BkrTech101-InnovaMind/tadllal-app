import React from 'react';
import Image from 'next/image';
import { FaEye, FaRegTrashCan, FaRegPenToSquare } from "react-icons/fa6";
const CustomTable = ({ columns, data, onEdit, onDelete }) => {
    return (
        <table className="w-full text-sm text-right text-blue-100 dark:text-blue-100" dir="rtl">
            <thead className="text-xs text-white uppercase bg-gradient-to-br from-minueActiveGraideint-100  to-minueActiveGraideint-100">
                <tr>
                    {columns.map((column) => (
                        <th key={column.key} scope="col" className="px-6 py-3">
                            {column.label}
                        </th>
                    ))}
                    <th key="Actions" scope="col" className="px-6 py-3">
                        خيارات
                    </th>
                </tr>
            </thead>
            <tbody>
                {data.map((item, index) => (
                    <tr
                        key={index}
                        className={`bg-${index % 2 === 0 ? 'white' : 'gray-50'} border-b dark:bg-white text-black`}
                    >
                        {columns.map((column) => (
                            <td key={column.key} className="px-6 py-4">
                                {column.render ? column.render(item) : item[column.key]}
                            </td>
                        ))}
                        <td key="Actions" className="px-0 py-7 flex flex-row items-center justify-evenly" >
                            <a href="" className="font-medium text-black dark:text-black hover:underline" onClick={() => onDelete(item)}>
                                <FaEye size={20} />
                            </a>
                            <a href="#" className="font-medium text-yellow-500 dark:text-yellow-500 hover:underline" onClick={() => onEdit(item)}>
                                <FaRegPenToSquare size={20} />
                            </a>

                            <a href="" className="font-medium text-red-600 dark:text-red-500 hover:underline" onClick={() => onDelete(item)}>
                                <FaRegTrashCan size={20} />
                            </a>


                        </td>
                    </tr>
                ))}
            </tbody>
        </table>
    );
};

export default CustomTable;
