<%@ Page Title="מבנה האתר" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SiteMap.aspx.cs" Inherits="SiteMap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin: 20px; text-align: center; padding: 20px;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px;">מבנה האתר</h2>
        
        <div style="max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1);">
            <div style="border: 2px solid #4CAF50; padding: 15px; margin: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                <h3 style="color: #4CAF50; margin-bottom: 10px;">דף הבית</h3>
                <p>הצגת מידע כללי על האתר ולוגו בית הספר</p>
            </div>

            <div style="display: flex; justify-content: center; margin: 15px 0; font-size: 24px; color: #2c3e50;">
                ↓
            </div>

            <div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
                <div style="border: 2px solid #2196F3; padding: 15px; margin: 10px; flex: 1; min-width: 200px; background: white; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                    <h3 style="color: #2196F3; margin-bottom: 10px;">למה בחרתי בנושא</h3>
                    <p>הסבר על בחירת נושא כדורגל</p>
                </div>

                <div style="border: 2px solid #2196F3; padding: 15px; margin: 10px; flex: 1; min-width: 200px; background: white; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                    <h3 style="color: #2196F3; margin-bottom: 10px;">טבלת קבוצות</h3>
                    <p>מידע על קבוצות הכדורגל</p>
                </div>

                <div style="border: 2px solid #2196F3; padding: 15px; margin: 10px; flex: 1; min-width: 200px; background: white; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                    <h3 style="color: #2196F3; margin-bottom: 10px;">הוספת קבוצה</h3>
                    <p>טופס להוספת קבוצה חדשה</p>
                </div>
            </div>

            <div style="display: flex; justify-content: center; margin: 15px 0; font-size: 24px; color: #2c3e50;">
                ↓
            </div>

            <div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
                <div style="border: 2px solid #FF9800; padding: 15px; margin: 10px; flex: 1; min-width: 200px; background: white; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                    <h3 style="color: #FF9800; margin-bottom: 10px;">הרשמה</h3>
                    <p>טופס הרשמה למשתמשים חדשים</p>
                </div>

                <div style="border: 2px solid #FF9800; padding: 15px; margin: 10px; flex: 1; min-width: 200px; background: white; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                    <h3 style="color: #FF9800; margin-bottom: 10px;">התחברות</h3>
                    <p>טופס התחברות למשתמשים רשומים</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>