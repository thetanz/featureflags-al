pageextension 50100 "CustomerListExt_FF_TSL" extends "Customer List"
{
    layout
    {
        // New control for LOCALS feature
        addafter(Name)
        {
            field("IsLocal_FF_TSL"; IsLocal)
            {
                Caption = 'Local';
                ToolTip = 'Indicates if customer is local.';
                ApplicationArea = LOCALS;
            }
        }
        // New control for STRIPE feature
        addafter(County)
        {
            field("StripeID_FF_TSL"; Rec.StripeID_FF_TSL)
            {
                Caption = 'Stripe ID';
                ToolTip = 'Customer Stripe ID.';
                ApplicationArea = STRIPE;
            }
        }
    }

    actions
    {
        // New action for LOCALS feature
        addafter(PaymentRegistration)
        {
            action("NewWelcomeLocalEmail_FF_TSL")
            {
                Caption = 'Send &Welcome Email';
                ToolTip = 'Sends local customer a warm welcome email.';
                Promoted = true;
                PromotedCategory = Process;
                Image = Email;
                Visible = Rec."E-Mail" <> '';
                ApplicationArea = LOCALS;

                trigger OnAction()
                var
                    CompanyInfo: Record "Company Information";
                    PrimaryContact: Record Contact;
                    EmailMessage: Codeunit "Email Message";
                    Email: Codeunit Email;
                begin
                    Rec.GetPrimaryContact(Rec."No.", PrimaryContact);
                    CompanyInfo.Get();
                    EmailMessage.Create(
                        Rec."E-Mail",
                        StrSubstNo(LocalEmailSubjectTxt, CompanyInfo.Name),
                        StrSubstNo(LocalEmailBodyTxt, PrimaryContact.Name),
                        true
                    );
                    Email.OpenInEditorModally(EmailMessage);
                end;
            }
        }
    }

    var
        IsLocal: Boolean;
        LocalEmailSubjectTxt: Label '%1 Welcome You', Comment = '%1 = Company Name';
        LocalEmailBodyTxt: Label 'Kia Ora %1,<p>We are locals, let''s catch up for a flat white!', Comment = '%1 = Primary Contact Full Name';

    trigger OnAfterGetRecord()
    var
        CompanyInfo: Record "Company Information";
    begin
        // New code for LOCALS feature
        if StrPos(ApplicationArea(), '#LOCALS,') <> 0 then begin
            CompanyInfo.Get();
            IsLocal := Rec."Country/Region Code" = CompanyInfo."Country/Region Code";
        end;
    end;
}