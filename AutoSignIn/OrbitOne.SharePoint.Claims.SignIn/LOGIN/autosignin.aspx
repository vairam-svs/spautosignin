<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Register Tagprefix="SharepointIdentity" Namespace="Microsoft.SharePoint.IdentityModel" Assembly="Microsoft.SharePoint.IdentityModel,
 Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Assembly Name="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"%> 
<%@ Page Language="C#" Inherits="OrbitOne.SharePoint.Claims.SignIn.AutoSignin" MasterPageFile="~/_layouts/15/errorv15.master" %> 
<%@ Import Namespace="Microsoft.SharePoint.WebControls" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, 
Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0,
 Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Import Namespace="Microsoft.SharePoint" %>
 <%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<asp:Content ID="Content2" ContentPlaceHolderId="PlaceHolderPageTitleInTitleArea" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderId="PlaceHolderMain" runat="server">
<style type="text/css">
        #content    {
        border: 1px 1px 1px 1px;
        border-color: black;
        border-style: solid;
        padding: 10px 0px 10px 10px;
        width: 615px;
        }

        #title	{
        color: #0066cc;
        font-face: Tahoma;
        font-size: 2em;
        line-height: 40px;
        }

        #auth	{
        font-weight: bold;
        font-size: 1.1em;
        margin-top: 10px;
        font-face: Trebuchet MS;
        }

    </style>
    <div id="content">
<div id="title">Welcome SharePoint</div>
 
<div id="auth">Choose an Authentication Provider to Login:</div>
<br />
<br />
<SharepointIdentity:LogonSelector ID="ClaimsLogonSelector" runat="server" />
</div>
</asp:Content>
<%--The following code should be removed if the SP environment contains both anonymous and Authenticated sites available within a FARM--%>
<asp:Content ContentPlaceHolderID="PlaceHolderGoBackLink" Visible="false" runat="server"></asp:Content>
