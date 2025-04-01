<%@ Page Title="למה בחרתי בנושא" Language="C#" MasterPageFile="~/MasterPage.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="explanation-section" style="text-align: center; padding: 20px; max-width: 800px; margin: 0 auto;">
        <h2 style="color: #2c3e50; font-size: 28px; margin-bottom: 30px; text-align: center;">למה בחרתי בנושא קבוצות כדורגל?</h2>
        
        <div class="reason-box" style="background-color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); text-align: center;">
            <h3 style="color: #3498db; margin-bottom: 10px;">חיבור אישי לספורט</h3>
            <p>אני אוהד כדורגל מילדות ותמיד התעניינתי בהיסטוריה של הקבוצות בישראל.</p>
        </div>

        <div class="reason-box" style="background-color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); text-align: center;">
            <h3 style="color: #3498db; margin-bottom: 10px;">חשיבות חברתית</h3>
            <p>כדורגל הוא חלק חשוב מהתרבות הישראלית ומחבר בין אנשים מכל המגזרים.</p>
        </div>

        <div class="reason-box" style="background-color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); text-align: center;">
            <h3 style="color: #3498db; margin-bottom: 10px;">למידה וסטטיסטיקה</h3>
            <p>הנושא מאפשר לי ללמוד על איסוף נתונים, ארגון מידע והצגתו בצורה ברורה.</p>
        </div>

        <div class="target-audience" style="background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.1); text-align: center;">
            <h3 style="color: #3498db; margin-bottom: 15px;">קהל היעד של האתר:</h3>
            <ul style="display: inline-block; text-align: right; list-style-position: inside; padding-right: 20px;">
                <li>אוהדי כדורגל המתעניינים בהיסטוריה של הקבוצות</li>
                <li>תלמידים הלומדים על ספורט ישראלי</li>
                <li>אנשים המחפשים מידע סטטיסטי על קבוצות הכדורגל</li>
            </ul>
        </div>
    </div>
</asp:Content>