import {Controller} from "@hotwired/stimulus"
import 'chartjs-plugin-datalabels';
const THOUSAND = 1000
const HUNDRED_THOUSAND = 100000
const MILLION = 1000000
const HUNDRED_MILLION = 100000000
const BILLION = 1000000000
const HUNDRED_BILLION = 100000000000
const TRILLION = 1000000000000

function numberFormatter(num) {
    if (num >= THOUSAND && num < MILLION) {
        const thousands = num / THOUSAND
        if (thousands === Math.floor(thousands) || num >= HUNDRED_THOUSAND) {
            return Math.floor(thousands) + 'k'
        } else {
            return (Math.floor(thousands * 10) / 10) + 'k'
        }
    } else if (num >= MILLION && num < BILLION) {
        const millions = num / MILLION
        if (millions === Math.floor(millions) || num >= HUNDRED_MILLION) {
            return Math.floor(millions) + 'M'
        } else {
            return (Math.floor(millions * 10) / 10) + 'M'
        }
    } else if (num >= BILLION && num < TRILLION) {
        const billions = num / BILLION
        if (billions === Math.floor(billions) || num >= HUNDRED_BILLION) {
            return Math.floor(billions) + 'B'
        } else {
            return (Math.floor(billions * 10) / 10) + 'B'
        }
    } else {
        return num
    }
}

export default class extends Controller {
    connect() {
        const funnel = JSON.parse(this.element.dataset.data);

        const getPalette = () => {
            return {
                dataLabelBackground: 'rgba(25, 30, 56, 0.97)',
                dataLabelTextColor: 'rgb(243, 244, 246)',
                visitorsBackground: 'rgb(99, 102, 241)',
                dropoffBackground: '#2F3949',
                dropoffStripes: 'rgb(25, 30, 56)',
                stepNameLegendColor: 'rgb(228, 228, 231)',
                visitorsLegendClass: 'bg-indigo-500',
                dropoffLegendClass: 'bg-gray-600',
                smallBarClass: 'bg-indigo-500'
            }
        }



        var fontFamily = 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"'
        const calcBarThickness = (ctx) => {
            if (ctx.dataset.data.length <= 3) {
                return 160
            } else {
                return Math.floor(650 / ctx.dataset.data.length)
            }
        }

        const labels = funnel.steps.map((step) => step.step)
        const stepData = funnel.steps.map((step) => step.count)
        const dropOffData = funnel.steps.map((step) => step.drop_off)

        const data = {
            labels: labels,
            datasets: [
                {
                    label: 'Visitors',
                    data: stepData,
                    borderRadius: 4,
                    stack: 'Stack 0',
                },
                {
                    label: 'Dropoff',
                    data: dropOffData,
                    borderRadius: 4,
                    stack: 'Stack 0',
                },
            ],
        }

        console.log(data)
        const config = {
            responsive:true,
            maintainAspectRatio: false,
            plugins: [ChartDataLabels],
            type: 'bar',
            data: data,
            options: {
                layout: {
                    padding: 100,
                },
                barThickness: calcBarThickness,
                plugins: {
                    legend: {
                        display: false,
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: true,
                        position: 'average',
                    },
                    datalabels: {
                        anchor: 'end',
                        align: 'end',
                        borderRadius: 4,
                        padding: { top: 8, bottom: 8, right: 8, left: 8 },
                        font: { size: 12, weight: 'normal', lineHeight: 1.6, family: fontFamily },
                        textAlign: 'center',
                    },
                },
                scales: {
                    y: { display: false },
                    x: {
                        position: 'bottom',
                        display: true,
                        border: { display: false },
                        grid: { drawBorder: false, display: false },
                        ticks: {
                            padding: 8,
                            font: { weight: 'bold', family: fontFamily, size: 14 },
                            color: 'rgb(228, 228, 231)'
                        },
                    },
                },
            },
        }

        const visitorsData = []

        new Chart(
            this.element,
            config
        );
    }
}
