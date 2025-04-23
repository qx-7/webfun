const csvCopy = document.getElementById("csvCopy");
csvCopy.addEventListener("click", function () {
    const csvText = document.getElementById('csv-text');
    csvText.select();
    navigator.clipboard.writeText(csvText.value).then(() => {
        /* clipboard successfully set */
    }, () => {
        /* clipboard write failed */
        window.alert('Copy to clipboard failed. Please copy manually.');
    });
});

const csvDownload = document.getElementById('csvDownload');
csvDownload.addEventListener('click', function () {
    const csvText = document.getElementById('csv-text');
    const csvContent = csvText.value;
    const facilityNumber = document.querySelector('input[name="facilityNumber"]').value;
    const facilityName = document.querySelector('input[name="facilityName"]').value;
    const fullDate = makeDateString();
    const fileName = facilityNumber + ' ' + facilityName + ' ' + fullDate + '.csv';
    if (csvContent == "") {
        window.alert('Download failed. Generate CSV first.');
    } else {
        downloadFunction(fileName, csvContent);
    }
});

function formPrint() {
	const mainSections = document.querySelectorAll('form > fieldset[id^="main"]');
    let scoreArray = [0, 0, 0, 0, 0, 0];
    let sections = new Array(mainSections.length);
    
    const mainElements = document.querySelectorAll('fieldset[id^="main"], .main, body > *:not(form)');
    mainElements.forEach(element => element.classList.add("printHidden"));
    
    mainSections.forEach(sectionIterate);
    sections.forEach(myFunction);
    
    function sectionIterate(section, i, arr) {
        let questions = section.querySelectorAll('fieldset.main');
        sections[i] = new Array(questions.length);
        questions.forEach(questionIterate, i);
        
        function questionIterate(question, j, arr) {
            const radios = question.querySelectorAll('input[type="radio"]');
            sections[i][j] = radios;
        }
    }
    
    function myFunction(section, i, arr) {
        section.forEach(otherFunction);
        
        function otherFunction(radioList, j, arr) {
            radioList.forEach(thatFunction);
            
            function thatFunction(radio, k, arr) {
                if (radio.checked) {
                    scoreArray[radio.value]++;
                    if (1 <= radio.value && radio.value <= 4) {
                        radio.parentNode.classList.remove('printHidden');
                        radio.parentNode.parentNode.classList.remove('printHidden');
                        radio.parentNode.parentNode.parentNode.classList.remove('printHidden');
                    }
                }
            }
        }
    }
    
    let scoreInputs = document.querySelectorAll('.score input:not([name$="t"])');
    
    scoreInputs.forEach(setScore);
    setTotal(scoreArray);
    
    function setScore(scoreInput, i, arr) {
        const name = scoreInput.getAttribute('name');
        const endIndex = name.length - 1;
        const scoreValue = name.substring(endIndex);
        if (0 < scoreValue && scoreValue < 4) {
            const scoreAmount = scoreArray[scoreValue];
            scoreInput.setAttribute("value", scoreAmount);
        }
    }
    
    window.print();
}

function formCSVHeaders() {
    let csvText = document.getElementById("csv-text");
    csvText.value = "";
    
    /* append the header data names */
    namesHeader();
    
    /* for the main stuff */
    namesMain();
    
    /* append notes and score names */
    csvText.value += '"inspectionNotes","score1","score2","score3","scoreTotal"';
    
    /* append newline */
    csvText.value += '\n';
    
    formCSV(csvText);
    
    function namesHeader() {
        const headerInfo = document.querySelectorAll('#facilityFieldset input, #inspectionFieldset input, #facilityFieldset select, #inspectionFieldset select');
        headerInfo.forEach(appendName);
    }
    
    function namesMain() {
        const questions = document.querySelectorAll('fieldset[id^="main"] input[value="0"]');
        questions.forEach(appendName);
    }
    
    function appendName(item) {
        csvText.value += '"' + item.name + '",';
    }
}

function formCSVNoHeaders() {
    let csvText = document.getElementById("csv-text");
    csvText.value = "";
    formCSV(csvText);
}

function formCSV(csvText) {
    const mainSections = document.querySelectorAll('form > fieldset[id^="main"]');
    let scoreArray = [0, 0, 0, 0, 0, 0];
    let sections = new Array(mainSections.length);
    
    appendHeader(); /* see below */
    
    mainSections.forEach(sectionIterate);
    function sectionIterate(section, i, arr) {
        let questions = section.querySelectorAll('fieldset.main');
        sections[i] = new Array(questions.length);
        questions.forEach(questionIterate, i);
        
        function questionIterate(question, j, arr) {
            const radios = question.querySelectorAll('input[type="radio"]');
            sections[i][j] = radios;
        }
    }
    
    sections.forEach(myFunction);
    function myFunction(section, i, arr) {
        section.forEach(otherFunction);
        
        function otherFunction(radioList, j, arr) {
            radioList.forEach(thatFunction);
            function thatFunction(radio, k, arr) {
                if (radio.checked) {
                    scoreArray[radio.value]++;
                    csvText.value += radio.value + ",";
                }
            }
        }
    }
    
    appendNotes(); /* see below */
    
    let scoreInputs = document.querySelectorAll('.score input:not([name$="t"])');
    
    scoreInputs.forEach(setScore);
    
    function setScore(scoreInput, i, arr) {
        const name = scoreInput.getAttribute('name');
        const endIndex = name.length - 1;
        const scoreValue = name.substring(endIndex);
        if (0 < scoreValue && scoreValue < 4) {
            const scoreAmount = scoreArray[scoreValue];
            scoreInput.setAttribute("value", scoreAmount);
        }
    }
    
    const finalScores = setTotal(scoreArray);
    
    appendScore();
    
    removeComma();
    
    /* form stuff below */
    
    /* append header info to csvText */
    function appendHeader() {
        const headerInfo = document.querySelectorAll('#facilityFieldset input, #inspectionFieldset input, #facilityFieldset select, #inspectionFieldset select');
        headerInfo.forEach(inputFunction);
    }
    
    /* append notes to csvText */
    function appendNotes() {
        const inspectionNotes = document.getElementById("notesTextarea");
        inputFunction(inspectionNotes);
    }
    
    /* append score values to csvText */
    function appendScore() {
        finalScores.forEach(scoreFunction);
        function scoreFunction(score,i) {
            csvText.value += score + ',';
        }
    }
    
    /* remove end comma */
    function removeComma() {
        csvText.value = csvText.value.substring(0,csvText.value.length-1);
    }
    
    /* function to append data to textarea#inspectionNotes, i.e. csvText */
    function inputFunction(infoField) {
        if (infoField.type == 'checkbox') {
            if(infoField.checked) {
                csvText.value += '1,';
            } else {
                csvText.value += '0,';
            }
        }
        else if (infoField.type == 'text' || infoField.nodeName == 'SELECT' || infoField.nodeName == 'TEXTAREA') {
            csvText.value += '"' + infoField.value + '"' + ',';
        } else {
            csvText.value += infoField.value + ',';
        }
    }
}

function setTotal(scoreArray) {
    const score1 = scoreArray[1];
    const score2 = scoreArray[2];
    const score3 = scoreArray[3];

    const weight1 = 1;
    const weight2 = 2;
    const weight3 = 3;

    const scoreTotal = (score1 * weight1) + (score2 * weight2) + (score3 * weight3);

    let totInput = document.querySelectorAll('.score input[name$="t"]');
    totInput.forEach(total);

    function total(tot, i, arr) {
        tot.setAttribute("value", scoreTotal);
    }
    
    const finalArray = new Array(4);
    finalArray[0] = score1;
    finalArray[1] = score2;
    finalArray[2] = score3;
    finalArray[3] = scoreTotal;
    return finalArray;
}

function makeDateString() {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    let month = currentDate.getMonth();
    let date = currentDate.getDate();
    month = makeTwoDigit(month);
    date = makeTwoDigit(date);
    const fullDate = year + month + date;
    
    let hour = currentDate.getHours();
    let minute = currentDate.getMinutes();
    let second = currentDate.getSeconds();
    hour = makeTwoDigit(hour);
    minute = makeTwoDigit(minute);
    second = makeTwoDigit(second);
    const fullTime = hour + minute + second;
    
    return fullDate + '-' + fullTime;
    
    function makeTwoDigit(input) {
        input = input.toString();
        if (input.length == 1) {
            input = '0' + input;
        }
        return input;
    }
}

function downloadFunction(filename, content) {
    let element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8, ' + encodeURIComponent(content));
    element.setAttribute('download', filename);
    document.body.appendChild(element);
    //onClick property
    element.click();
    document.body.removeChild(element);
}
