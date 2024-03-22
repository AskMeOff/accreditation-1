

let checkContacktValue = false; 
let arrOblastId_journal_rkk = [];
let arrOblastSTR_journal_rkk = [];

function CheckCheckBoxElement(elem, element_name){
    
    let checkBox = document.getElementById(`checkbox_${element_name}`);

    if(elem != 'checkBox'){
        
        checkBox.checked = !checkBox.checked;
    }
    

    // if(!btnReportPrint.hasAttribute('disabled')){
    //     btnReportPrint.setAttribute('disabled','true')
    // }
}


function CheckCheckBoxOblastElement(elem, index){

    let checkBox = document.getElementById(`checkbox_oblast_${index}`);
    if(elem != 'checkBox'){   
        checkBox.checked = !checkBox.checked;
    }

    let oblast = document.getElementsByClassName('oblast');

    if(index===0){
        if (oblast.length !== 0) {
            for (let i = 0; i < oblast.length; i++) {
                let checkBox1 = document.getElementById(`checkbox_oblast_${oblast[i].id}`);
                checkBox1.checked = checkBox.checked;
            }
        }
    }


    if(index!==0){
        let checkBox1 = document.getElementById(`checkbox_oblast_0`);
        checkBox1.checked = false;
    }

    
    

    // if(!btnReportPrint.hasAttribute('disabled')){
    //     btnReportPrint.setAttribute('disabled','true')
    // }
}

function disablePrint(){
    // let btnReportPrint = document.getElementById(`btnReportPrint`);

    // if(!btnReportPrint.hasAttribute('disabled')){
    //     btnReportPrint.setAttribute('disabled','true')
    // }


}

function validateDate(date_at, date_to, date_name){
    
    let div_date_name = document.getElementById(date_name).innerText;
  
    if((date_at && !date_to) || (!date_at && date_to)){
        alert(`Неверно заполнено поле ${div_date_name}`)
        return -1
    } else {
        if(date_at>date_to) {
            alert(`Неверно заполнено поле ${div_date_name}`)
            return -1
        } else {
            if(date_at && date_to){
                return 1
            } else {
                return 0
            }
        }
    }
   
}

function preperaReport(){
    
    let dataParametrs = {
        with_contact: 0,
        zaregal:0,
        info:0,
        date_reg_at: null,
        date_reg_to: null, 
        date_protokol_at: null, 
        date_protokol_to: null, 
        date_admin_resh_at: null, 
        date_admin_resh_to: null, 
        date_sved_at: null, 
        date_sved_to: null, 
        date_delo_at: null, 
        date_delo_to: null, 
        date_reg : 0 ,
        date_protokol: 0,
        date_admin_resh: 0,
        date_sved :0, 
        date_delo: 0,
        checkbox_adm_resh_1: false, 
        checkbox_adm_resh_2: false, 
        checkbox_adm_resh_3: false, 
        adm_resh:0,
        checkbox_pervtor_1: false,
        checkbox_pervtor_2: false,
        pervtor: 0,
        checkAllOblast : false,
        checkOblasts : '',
        checkOblastsId : '',
        otz: false,
        otkaz: false,

    }

    let checkbox_with_contact = document.getElementById(`checkbox_with_contact`).checked;
    dataParametrs.with_contact = checkbox_with_contact;

    let checkbox_zaregal = document.getElementById(`checkbox_zaregal`).checked;
    dataParametrs.zaregal = checkbox_zaregal;

    let checkbox_info = document.getElementById(`checkbox_info`).checked;
    dataParametrs.info = checkbox_info;  

    let date_reg_at = document.getElementById(`date_reg_at`);
    let date_reg_at_value = date_reg_at.value;

    dataParametrs.date_reg_at = date_reg_at_value;
    let date_reg_to = document.getElementById(`date_reg_to`);
    let date_reg_to_value = date_reg_to.value;
    dataParametrs.date_reg_to = date_reg_to_value;

    let date_reg = validateDate(date_reg_at_value, date_reg_to_value, 'date_reg')
    if (date_reg == -1){
        return
    }
    dataParametrs.date_reg = date_reg


    let date_protokol_at = document.getElementById(`date_protokol_at`);
    let date_protokol_at_value = date_protokol_at.value;
    dataParametrs.date_protokol_at = date_protokol_at_value;

    let date_protokol_to = document.getElementById(`date_protokol_to`);
    let date_protokol_to_value = date_protokol_to.value;
    dataParametrs.date_protokol_to = date_protokol_to_value;

    let date_protokol = validateDate(date_protokol_at_value, date_protokol_to_value, 'date_protokol')
    if (date_protokol == -1){
        return
    }
    dataParametrs.date_protokol = date_protokol;

    let date_admin_resh_at = document.getElementById(`date_admin_resh_at`);
    let date_admin_resh_at_value = date_admin_resh_at.value;
    dataParametrs.date_admin_resh_at = date_admin_resh_at_value;

    let date_admin_resh_to = document.getElementById(`date_admin_resh_to`);
    let date_admin_resh_to_value = date_admin_resh_to.value;
    dataParametrs.date_admin_resh_to = date_admin_resh_to_value;

    let date_admin_resh = validateDate(date_admin_resh_at_value, date_admin_resh_to_value, 'date_admin_resh')
    if (date_admin_resh == -1){
        return
    }
    dataParametrs.date_admin_resh = date_admin_resh;

    let date_sved_at = document.getElementById(`date_sved_at`);
    let date_sved_at_value = date_sved_at.value;
    dataParametrs.date_sved_at = date_sved_at_value;

    let date_sved_to = document.getElementById(`date_sved_to`);
    let date_sved_to_value = date_sved_to.value;
    dataParametrs.date_sved_to = date_sved_to_value;

    let date_sved = validateDate(date_sved_at_value, date_sved_to_value, 'date_sved')
    if (date_sved == -1){
        return
    }
    dataParametrs.date_sved = date_sved;

    let date_delo_at = document.getElementById(`date_delo_at`);
    let date_delo_at_value = date_delo_at.value;
    dataParametrs.date_delo_at = date_delo_at_value;

    let date_delo_to = document.getElementById(`date_delo_to`);
    let date_delo_to_value = date_delo_to.value;
    dataParametrs.date_delo_to = date_delo_to_value;

    let date_delo = validateDate(date_delo_at_value, date_delo_to_value, 'date_delo')
    if (date_delo == -1){
        return
    }
    dataParametrs.date_delo = date_delo;

    /*
    if( date_reg == 0 &&  date_protokol== 0 && date_admin_resh== 0 && date_sved==0 && date_delo== 0){
        alert(`Не задан ни один отчетный период`)
        return
    }
     */   

    let checkbox_adm_resh_1 = document.getElementById(`checkbox_adm_resh_1`);
    let checkbox_adm_resh_1_value = checkbox_adm_resh_1.checked;
    dataParametrs.checkbox_adm_resh_1 = checkbox_adm_resh_1_value;

    let checkbox_adm_resh_2 = document.getElementById(`checkbox_adm_resh_2`);
    let checkbox_adm_resh_2_value = checkbox_adm_resh_2.checked;
    dataParametrs.checkbox_adm_resh_2 = checkbox_adm_resh_2_value;
    
    let checkbox_adm_resh_3 = document.getElementById(`checkbox_adm_resh_3`);
    let checkbox_adm_resh_3_value = checkbox_adm_resh_3.checked;
    dataParametrs.checkbox_adm_resh_3 = checkbox_adm_resh_3_value;

    let adm_resh = 0
    if(checkbox_adm_resh_1_value || checkbox_adm_resh_2_value || checkbox_adm_resh_3_value){
        adm_resh = 1 
    }
    dataParametrs.adm_resh = adm_resh;

   // console.log('adm_resh ', adm_resh)

    let checkbox_pervtor_1 = document.getElementById(`checkbox_pervtor_1`);
    let checkbox_pervtor_1_value = checkbox_pervtor_1.checked;
    dataParametrs.checkbox_pervtor_1 = checkbox_pervtor_1.checked;

    let checkbox_pervtor_2 = document.getElementById(`checkbox_pervtor_2`);
    let checkbox_pervtor_2_value = checkbox_pervtor_2.checked;
    dataParametrs.checkbox_pervtor_2= checkbox_pervtor_2.checked;

    if(checkbox_pervtor_2_value || checkbox_pervtor_1_value){
        dataParametrs.pervtor= 1;
    } else {
        dataParametrs.pervtor= 0;  
    }
    

    let checkAllOblast = document.getElementById(`checkbox_oblast_0`).checked;
    dataParametrs.checkAllOblast= checkAllOblast;
   
    ReportCheckedOblast()
    dataParametrs.checkOblasts= arrOblastSTR_journal_rkk.toString();
    dataParametrs.checkOblastsId= arrOblastId_journal_rkk.toString();
    
   // console.log(dataParametrs) 

    let checkbox_otz = document.getElementById(`checkbox_otz`);
    dataParametrs.otz = checkbox_otz.checked;

    let checkbox_otkaz = document.getElementById(`checkbox_otkaz`);
    dataParametrs.otkaz = checkbox_otkaz.checked;



    reportPrepere(dataParametrs)

    let reportRow = document.getElementById('reportRow');
    reportRow.style="background-color: white";
}

function ReportCheckedOblast(){

    arrOblastId_journal_rkk = [];
    arrOblastSTR_journal_rkk = [];

    let oblast = document.getElementsByClassName('oblast');
        if (oblast.length !== 0) {
            for (let i = 1; i < oblast.length; i++) {
                let checkBox = document.getElementById(`checkbox_oblast_${oblast[i].id}`);
                if(checkBox.checked){
                    arrOblastId_journal_rkk = [...arrOblastId_journal_rkk, oblast[i].id];

                    let spanCheckBox = document.getElementById(`span_oblast_${oblast[i].id}`).innerText;
                    arrOblastSTR_journal_rkk = [...arrOblastSTR_journal_rkk, spanCheckBox ]
                }
                
            }
        } 
    

}


function prepereTableReport(dataParametrs){

    let table = document.createElement('table');
    table.id="printMe"
   
    table.style = "border-spacing: 0; border: none";

    let thead1 = document.createElement('thead');

    let trHead = document.createElement('tr');

    let th1 = document.createElement('th');
    th1.innerHTML = 'Рег. индекс';
    th1.style = "border: 1px solid black; width: 5%; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th2 = document.createElement('th');
    th2.innerHTML = 'дробь (/000%) Рег. индекс';
    th2.style = "border: 1px solid black; width: 5%; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th_1 = document.createElement('th');
    th_1.innerHTML = '№ заявления';
    th_1.style = "border: 1px solid black; width: 5%; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"
    
    let th3 = document.createElement('th');
    th3.innerHTML = 'Наименование Юр. Лицо';
    th3.style = "border: 1px solid black; min-width: 400px; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"


    let th4 = document.createElement('th');
    th4.innerHTML = 'первичный/повторный';
    th4.style = "border: 1px solid black; width: 10%; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th5 = document.createElement('th');
    th5.innerHTML = 'Дата регистрации';
    th5.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"


    let th6 = document.createElement('th');
    th6.innerHTML = 'Юр. Адрес';
    th6.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"
    
    let th7 = document.createElement('th');
    th7.innerHTML = 'Фактич. Адрес';
    th7.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"
    
    let th8 = document.createElement('th');
    th8.innerHTML = 'телефон';
    th8.style = "border: 1px solid black; min-width: 200px; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"
    
    let th9 = document.createElement('th');
    th9.innerHTML = 'Email';
    th9.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"  

    let th10 = document.createElement('th');
    th10.innerHTML = 'Административное решение';
    th10.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th11 = document.createElement('th');
    th11.innerHTML = 'Номер административного решения';
    th11.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"
   
    let th12 = document.createElement('th');
    th12.innerHTML = 'Дата административного решения';
    th12.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

  

    let th14 = document.createElement('th');
    th14.innerHTML = 'Номер свидетельства';
    th14.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th15 = document.createElement('th');
    th15.innerHTML = 'Срок действия сетрификата';
    th15.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th16 = document.createElement('th');
    th16.innerHTML = 'Срок действия';
    th16.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th17 = document.createElement('th');
    th17.innerHTML = 'Отметка о снятии контроля';
    th17.style = "border: 1px solid black; min-width: 125px; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th18 = document.createElement('th');
    th18.innerHTML = 'Документ в дело номер';
    th18.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th19 = document.createElement('th');
    th19.innerHTML = 'Зарегистрировал';
    th19.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th20 = document.createElement('th');
    th20.innerHTML = 'Уведомление';
    th20.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th21 = document.createElement('th');
    th21.innerHTML = 'Получил свидетельство ФИО, дата';
    th21.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"

    let th22 = document.createElement('th');
    th22.innerHTML = 'Регион';
    th22.style = "border: 1px solid black; text-align: left; line-height: normal; padding: 0.2rem 0.75rem;"


    trHead.appendChild(th1);
    trHead.appendChild(th2);
    trHead.appendChild(th_1);
    trHead.appendChild(th3);

    if(dataParametrs.pervtor === true){
        trHead.appendChild(th4);
    }
    
    trHead.appendChild(th5);
    if(dataParametrs.with_contact === true){

        trHead.appendChild(th6);
        trHead.appendChild(th7);
        trHead.appendChild(th8);
        trHead.appendChild(th9);
    }
    trHead.appendChild(th10);
    trHead.appendChild(th11);
    trHead.appendChild(th12);
    trHead.appendChild(th14);
    trHead.appendChild(th15);
//    trHead.appendChild(th16);
    trHead.appendChild(th17);
    trHead.appendChild(th18);
    if(dataParametrs.zaregal === true){
        trHead.appendChild(th19);
    }
    if(dataParametrs.info === true){
        trHead.appendChild(th20);
        trHead.appendChild(th21);
    }
    
    
    trHead.appendChild(th22);
    thead1.appendChild(trHead);
    table.appendChild(thead1);

    return table
}


function reportPrepere(dataParametrs){
    let divForTable = document.getElementById(`divForTable`);
    divForTable.innerHTML = '';

    let table = prepereTableReport(dataParametrs)

    let data = new Array();
    $.ajax({
        url: "modules/journal_rkk/getJournalRkk.php",
        method: "GET",
        data: {
            date_reg_at: dataParametrs.date_reg_at,
            date_reg_to: dataParametrs.date_reg_to, 
            date_protokol_at: dataParametrs.date_protokol_at, 
            date_protokol_to: dataParametrs.date_protokol_to, 
            date_admin_resh_at: dataParametrs.date_admin_resh_at, 
            date_admin_resh_to: dataParametrs.date_admin_resh_to, 
            date_sved_at: dataParametrs.date_sved_at, 
            date_sved_to: dataParametrs.date_sved_to, 
            date_delo_at: dataParametrs.date_delo_at, 
            date_delo_to: dataParametrs.date_delo_to, 
            date_reg : dataParametrs.date_reg,
            date_protokol: dataParametrs.date_protokol,
            date_admin_resh: dataParametrs.date_admin_resh,
            date_sved : dataParametrs.date_sved, 
            date_delo:  dataParametrs.date_delo,
            checkbox_adm_resh_1: dataParametrs.checkbox_adm_resh_1, 
            checkbox_adm_resh_2: dataParametrs.checkbox_adm_resh_2, 
            checkbox_adm_resh_3: dataParametrs.checkbox_adm_resh_3, 
            adm_resh: dataParametrs.adm_resh,
            checkbox_pervtor_1: dataParametrs.checkbox_pervtor_1,
            checkbox_pervtor_2: dataParametrs.checkbox_pervtor_2,
            pervtor: dataParametrs.pervtor,
            checkAllOblast : dataParametrs.checkAllOblast,
            checkOblasts : dataParametrs.checkOblasts,
            checkOblastsId : dataParametrs.checkOblastsId,
            otz: dataParametrs.otz,
            otkaz: dataParametrs.otkaz

        }
        
    }).done(function (response){
        for (let i of JSON.parse(response)){
            data.push(i);
        }

      //  console.log(JSON.parse(response))

        
        let tbody = document.createElement('tbody');
        table.appendChild(tbody);

        if(data.length > 0){
            data.map((item,index) => {

                                                
                let tr = document.createElement('tr');
                let td1 = document.createElement('td');
                td1.innerHTML = item['id_rkk'];
                td1.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td2 = document.createElement('td');
                td2.innerHTML = item['num_rkk'];
                td2.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";
                              
                let td_1 = document.createElement('td');
                td_1.innerHTML = item['id_application'];
                td_1.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td3 = document.createElement('td');
                td3.innerHTML = item['naim'];
                td3.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td4 = document.createElement('td');
                td4.innerHTML = item['perv_vtor'];
                td4.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td5 = document.createElement('td');
                td5.innerHTML = item['date_reg'];
                td5.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                
                    let td6 = document.createElement('td');
                    td6.innerHTML = item['ur_adress'];
                    td6.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                    let td7 = document.createElement('td');
                    td7.innerHTML = item['fact_adress'];
                    td7.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                    let td8 = document.createElement('td');
                    td8.innerHTML = item['tel'];
                    td8.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                    let td9 = document.createElement('td');
                    td9.innerHTML = item['email'];
                    td9.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";
                

                let td10 = document.createElement('td');
                td10.innerHTML = item['adm_reah'];
                td10.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td11 = document.createElement('td');
                td11.innerHTML = item['adm_resh_num'];
                td11.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td12 = document.createElement('td');
                td12.innerHTML = item['date_admin_resh'];
                td12.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td14 = document.createElement('td');
                td14.innerHTML = item['svidetelstvo'];
                td14.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td15 = document.createElement('td');
                td15.innerHTML = item['date_sved'];
                td15.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td16 = document.createElement('td');
                td16.innerHTML = item['sved_srok_deist'];
                td16.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td17 = document.createElement('td');
                td17.innerHTML = item['date_delo'];
                td17.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td18 = document.createElement('td');
                td18.innerHTML = item['delo'];
                td18.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td19 = document.createElement('td');
                td19.innerHTML = item['zaregal'];
                td19.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";
                
                let td20 = document.createElement('td');
                td20.innerHTML = item['info_uved'];
                td20.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td21 = document.createElement('td');
                td21.innerHTML = item['getter'];
                td21.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";

                let td22 = document.createElement('td');
                td22.innerHTML = item['oblast'];
                td22.style = "border-bottom: 1px dashed black; padding: 0.2rem 0.75rem;text-align:center;line-height: normal; ";
                
                
                tr.appendChild(td1);
                tr.appendChild(td2);
                tr.appendChild(td_1);
                tr.appendChild(td3);

                if(dataParametrs.pervtor === true){
                    tr.appendChild(td4);
                }

                tr.appendChild(td5);

                if(dataParametrs.with_contact === true){
                    tr.appendChild(td6);
                    tr.appendChild(td7);
                    tr.appendChild(td8);
                    tr.appendChild(td9);
                }
                tr.appendChild(td10);
                tr.appendChild(td11);
                tr.appendChild(td12);
                tr.appendChild(td14);
                tr.appendChild(td15);
            //    tr.appendChild(td16);
                tr.appendChild(td17);
                tr.appendChild(td18);
                if(dataParametrs.zaregal === true){
                    tr.appendChild(td19);
                }
                if(dataParametrs.info === true){
                    tr.appendChild(td20);
                    tr.appendChild(td21);
                }
                
                
                tr.appendChild(td22);
                
                tbody.appendChild(tr);

            })
       } else {
        
        let divForTable = document.getElementById(`divForTable`);
        divForTable.innerHTML = '';
        divForTable.innerHTML = 'По данным параметрам нет записей';

       }


    })


   // let table = prepereTableReport()

    /*
    

    $.ajax({
        url: "modules/report/report_analiz_ocenka/getReportOcenkaWithOutYurLica.php",
        method: "GET",
        data: {}
        
    }).done(function (response){
        

         let divReportTitle = document.createElement('div');
         divReportTitle.style = "padding-top: 0.5rem; padding-bottom:1rem; font-size:2rem; text-align:center";

        let select1 = document.getElementById("oblast");
        let value1 = select1.options[select1.selectedIndex].innerText;

        let select2 = document.getElementById("status");
        let value2 = select2.options[select2.selectedIndex].innerText;

        let date1 = document.getElementById("dateAccept");
        let date2 = document.getElementById("dateComplete");
        let typeO = document.getElementById("typeOrg");
        let value3 = typeO.options[typeO.selectedIndex].innerText;

        divReportTitle.textContent = `Анализ результатов медицинской аккредитации`;
        //: регион "` + value1 +`", со статусом "` + value2 + `", в период с `+  new Date(date1.value).toLocaleDateString() +` по ` +  new Date(date2.value).toLocaleDateString() +`; тип организации "` + value3 +`"`;

         let divReportUsl = document.createElement('div');
         divReportUsl.id = 'divReportUsl';
         divReportUsl.style = "padding-top: 0.5rem; padding-bottom:1rem; font-size:1.2rem; line-height: normal;";
         divReportUsl.textContent = '<b>' + `Условия отбора:`+'</b>';
         divReportUsl.innerHTML = divReportUsl.textContent + '<br/>'

           divReportUsl.innerHTML = divReportUsl.innerHTML + '<b>' +' Статус: '+'</b>' + status_text + '<br/>'

           if(status_value!=1) {
            divReportUsl.innerHTML = divReportUsl.innerHTML + '<b>' +' Период:'+'</b>' + ' с' + dateAccept_value + ' по ' + dateComplete_value + '<br/>'
           }

           divReportUsl.innerHTML = divReportUsl.innerHTML + '<b>' + ' Область:'+'</b>' + oblast_text + '<br/>'
           divReportUsl.innerHTML = divReportUsl.innerHTML + '<b>' +' Тип организации: '+'</b>' + typeOrg_text + '<br/>'
           
           
           divReportUsl.innerHTML = divReportUsl.innerHTML +   '<b>' +' Таблицы критериев: '+'</b>' + criteriaAll_text;
          
           if((criteriaAll_value == 1) && (arrCriteriaStr_report_analiz_ocenka.length>0)) {
                let arr =  arrCriteriaStr_report_analiz_ocenka.map(item=>{
                    return item.criteria_name
                })
            divReportUsl.innerHTML = divReportUsl.innerHTML + '<br/>'+   '<b>' +' По критериям: '+'</b>' + arr;
           }
           

        //   divReportUsl.setAttribute('hidden','true');

         
            divForTable.appendChild(divReportTitle);         
            divForTable.appendChild(divReportUsl);         
            divForTable.appendChild(table); 
         

    });

    */

    let divTable = document.createElement('div');
    divTable.id = 'divTable'
    let butnJournal = document.getElementById('butnJournal');
    
    let contentWidth = butnJournal.clientWidth - 32;
    
    divTable.style = `overflow-x:auto; max-width: ${contentWidth}px;overflow-block: visible; max-height: 600px;`;
    
    divTable.appendChild(table); 
    divForTable.appendChild(divTable); 
    
}



function printReport(){
    
    var WinPrint = window.open('g','g','left=50,top=50,toolbar=0,scrollbars=0,status=0');
    WinPrint.document.write('<style>@page {\n' +
        'size: legal landscape;\n' +
        'margin: 1rem;\n' +
        '}</style>');
    
 
   // WinPrint.document.write(divReportTitle.innerHTML);    
    let divForTable = document.getElementById('divForTable');    
    let divTable = document.getElementById('divTable');    

     let butnJournal = document.getElementById('butnJournal');
    
    let contentWidth = butnJournal.clientWidth - 32;
    divTable.style = ``;
   // let divReportUsl = document.getElementById('divReportUsl');    
   // divReportUsl.removeAttribute('hidden');
   


    WinPrint.document.write(divForTable.innerHTML);
   

    WinPrint.document.close();
    WinPrint.focus();
    WinPrint.print();
    WinPrint.close();

    divTable.style = `overflow-x:auto; max-width: ${contentWidth}px;overflow-block: visible; max-height: 600px;`;
   // divReportUsl.setAttribute('hidden','true');
}
