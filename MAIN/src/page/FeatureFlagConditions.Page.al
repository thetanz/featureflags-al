page 58539 "FeatureFlagConditions_FF_TSL"
{
    PageType = List;
    SourceTable = FeatureFlagCondition_FF_TSL;
    Caption = 'Conditions';
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ConditionCode; Rec.ConditionCode)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Satisfied := FeatureFlagMgt.IsConditionSatisfied(Rec.ConditionCode)
                    end;
                }
                field(SatisfiedField; Satisfied)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Satisfied';
                }
            }
        }
    }
    var
        FeatureFlagMgt: Codeunit FeatureFlagMgt_FF_TSL;
        Satisfied: Boolean;

    trigger OnAfterGetRecord()
    begin
        Satisfied := FeatureFlagMgt.IsConditionSatisfied(Rec.ConditionCode)
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Satisfied := false
    end;
}