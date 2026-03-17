import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./pages/LoginPage";
import AdminDashboard from "./pages/admin/AdminDashboard";
import MerchantDashboard from "./pages/merchant/MerchantDashboard";
import ProtectedRoute from "./components/ProtectedRoute";
import MerchantRegister from "./pages/MerchantRegister";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/login" />} />
        <Route path="/login" element={<LoginPage />} />
        <Route
          path="/admin/*"
          element={
            <ProtectedRoute role="ADMIN">
              <AdminDashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/merchant/*"
          element={
            <ProtectedRoute role="MERCHANT">
              <MerchantDashboard />
            </ProtectedRoute>
          }
        />
        <Route 
        path="/merchant/register" 
        element={
        <MerchantRegister />} />
      </Routes>
    </BrowserRouter>
  );
}
