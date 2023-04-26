// This file contains your Data Connector logic
[Version = "1.0.0"]
section OrangeHRM;

[DataSource.Kind = "OrangeHRM", Publish = "OrangeHRM.Publish"]
shared OrangeHRM.Contents = Value.ReplaceType(ContentsFunc, ContentsFuncType);

ContentsFunc = (BaseURL as text, Entity as text) =>
    let
        client_id = Extension.CurrentCredential()[Username],
        client_secret = Extension.CurrentCredential()[Password],
        base_url = BaseURL,
        // base_url = "https://demo-declan.orangehrmlive.com",
        body = "grant_type=client_credentials&client_id=" & client_id & "&client_secret=" & client_secret,
        Source = Json.Document(
            Web.Contents(
                base_url,
                [
                    RelativePath = "oauth/issueToken",
                    Headers = [#"Content-Type" = "application/x-www-form-urlencoded"],
                    Content = Text.ToBinary(body)
                ]
            )
        ),
        token = Source[access_token],
        data = Json.Document(
            Web.Contents(
                base_url,
                [
                    RelativePath = "/api/reports/v_pbi_employee_v1",
                    Query = [#"page[offset]" = Number.ToText(0), #"page[limit]" = Number.ToText(100)],
                    Headers = [#"Authorization" = "Bearer " & token]
                ]
            )
        ),
        data1 = data[data],
        #"Converted to Table" = Table.FromList(data1, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expanded Column1" = Table.ExpandRecordColumn(
            #"Converted to Table",
            "Column1",
            {
                "employee_key",
                "employee_id",
                "emp_status",
                "emp_firstname",
                "emp_middlename",
                "emp_lastname",
                "emp_fullname",
                "emp_work_email",
                "emp_mobile",
                "emp_work_telephone",
                "emp_dob",
                "emp_driving_license_exp_date",
                "emp_marital_status",
                "emp_gender",
                "emp_eeo_race_ethnicity",
                "emp_nationality",
                "emp_supervisor_key_list",
                "emp_supervisor_type_list",
                "emp_supervisor_count",
                "emp_other_id",
                "emp_creation_date",
                "emp_termination_date",
                "emp_termination_reason",
                "emp_purge_date",
                "emp_custom_name_list",
                "emp_custom_value_list"
            },
            {
                "employee_key",
                "employee_id",
                "emp_status",
                "emp_firstname",
                "emp_middlename",
                "emp_lastname",
                "emp_fullname",
                "emp_work_email",
                "emp_mobile",
                "emp_work_telephone",
                "emp_dob",
                "emp_driving_license_exp_date",
                "emp_marital_status",
                "emp_gender",
                "emp_eeo_race_ethnicity",
                "emp_nationality",
                "emp_supervisor_key_list",
                "emp_supervisor_type_list",
                "emp_supervisor_count",
                "emp_other_id",
                "emp_creation_date",
                "emp_termination_date",
                "emp_termination_reason",
                "emp_purge_date",
                "emp_custom_name_list",
                "emp_custom_value_list"
            }
        )
    in
        #"Expanded Column1";

ContentsFuncType = type function (
    BaseURL as text,
    Entity as (
        type text meta [
            Documentation.Name = "Entity",
            Documentation.Description = "Select a entity.",
            Documentation.SampleValues = {"z_pbi_employee_v1"},
            Documentation.AllowedValues = {"z_pbi_employee_v1", "z_pbi_attendance_v1", "z_pbi_leave_v1"}
        ]
    )
) as table meta [
    Documentation.Name = "OrangeHRM API"
];

// Data Source Kind description
OrangeHRM = [
    Authentication = [
        // Key = [],
        UsernamePassword = [
            UsernameLabel = "Client ID",
            PasswordLabel = "Client Secret"
        ]
        // Windows = [],
        // Anonymous = []
    ]
];

// Data Source UI publishing description
OrangeHRM.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = {Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp")},
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = OrangeHRM.Icons,
    SourceTypeImage = OrangeHRM.Icons
];

OrangeHRM.Icons = [
    Icon16 = {
        Extension.Contents("OrangeHRM16.png"),
        Extension.Contents("OrangeHRM20.png"),
        Extension.Contents("OrangeHRM24.png"),
        Extension.Contents("OrangeHRM32.png")
    },
    Icon32 = {
        Extension.Contents("OrangeHRM32.png"),
        Extension.Contents("OrangeHRM40.png"),
        Extension.Contents("OrangeHRM48.png"),
        Extension.Contents("OrangeHRM64.png")
    }
];
