import { BrowserRouter, Routes, Route } from "react-router-dom";
import LoginPage from "./pages/LoginPage";
import AdminDashboard from "./pages/admin/AdminDashboard";
import MerchantDashboard from "./pages/merchant/MerchantDashboard";
import ProtectedRoute from "./components/ProtectedRoute";
import MerchantRegister from "./pages/MerchantRegister";
import { ThemeProvider } from "./context/ThemeContext.jsx";
import LandingPage from "./pages/LandingPage.jsx";

export default function App() {
  return (
    <ThemeProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<LandingPage />} />         
          <Route path="/login" element={<LoginPage />} />
          <Route path="/merchant/register" element={<MerchantRegister />} />
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
        </Routes>
      </BrowserRouter>
    </ThemeProvider>
  );
}