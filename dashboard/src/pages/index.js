// import Card from '@/Components/Card'
import CardList from '@/Components/CardList'
import Sidebar from '@/Components/Sidebar'
import Table from '@/Components/Table'
import UserTable from '@/Components/UserTable'
import Nav from '@/Components/Navbar'
import Image from 'next/image'
import React from "react";
import Dashboard from "@/pages/Dashboard"
import Layout from '@/layout/Layout'

export default function Home() {
  return (

    <Layout>
      <CardList />
      <CardList />
      <CardList />
    </Layout>

  )
}
