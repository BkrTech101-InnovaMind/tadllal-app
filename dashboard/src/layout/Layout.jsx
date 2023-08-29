import Nav from "@/Components/Navbar"
import Sidebar from "@/Components/Sidebar"

export default function Layout({ children }) {
  return (
    <div className='flex flex-row bg-backGraound' dir='rtl'>
      <Sidebar />
      <div className='flex-1 flex-col w-full p-4 bg-backGraound'>
        <Nav />
        {children}
      </div>
    </div>
  )
}
