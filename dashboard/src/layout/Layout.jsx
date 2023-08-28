import Nav from '@/Components/Navbar'
import Sidebar from '@/Components/Sidebar'
import React from 'react'

export default function Layout({ children }) {
    return (
        <div className="flex flex-row-reverse bg-backGraound w-full">
            <Sidebar />
            <div className="flex flex-col w-full  p-4 bg-backGraound">
                <Nav />
                {children}
            </div>
        </div>
    )
}
