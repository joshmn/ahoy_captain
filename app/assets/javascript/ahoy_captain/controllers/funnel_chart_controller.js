import {Controller} from "@hotwired/stimulus"
import 'chartjs-plugin-datalabels';
const THOUSAND = 1000
const HUNDRED_THOUSAND = 100000
const MILLION = 1000000
const HUNDRED_MILLION = 100000000
const BILLION = 1000000000
const HUNDRED_BILLION = 100000000000
const TRILLION = 1000000000000
function FunnelTooltip(palette, funnel) {
    return (context) => {
        const tooltipModel = context.tooltip
        const dataIndex = tooltipModel.dataPoints[0].dataIndex
        const offset = document.querySelector('[data-controller="funnel-chart"]').getBoundingClientRect()
        let tooltipEl = document.getElementById('chartjs-tooltip')

        if (!tooltipEl) {
            tooltipEl = document.createElement('div')
            tooltipEl.id = 'chartjs-tooltip'
            tooltipEl.style.display = 'none'
            tooltipEl.style.opacity = 0
            document.body.appendChild(tooltipEl)
        }

        if (tooltipEl && offset && window.innerWidth < 768) {
            tooltipEl.style.top = offset.y + offset.height + window.scrollY + 15 + 'px'
            tooltipEl.style.left = offset.x + 'px'
            tooltipEl.style.right = null
            tooltipEl.style.opacity = 1
        }

        if (tooltipModel.opacity === 0) {
            tooltipEl.style.display = 'none'
            return
        }


        if (tooltipModel.body) {
            const currentStep = funnel.steps[dataIndex]
            const previousStep = (dataIndex > 0) ? funnel.steps[dataIndex - 1] : null

            tooltipEl.innerHTML = `
        <aside class="text-gray-100 flex flex-col">
          <div class="flex justify-between items-center border-b-2 border-gray-700 pb-2">
            <span class="font-semibold mr-4 text-lg">${previousStep ? `<span class="mr-2">${previousStep.label}</span>` : ""}
              <span class="text-gray-500 mr-2">→</span>
              ${tooltipModel.title}
            </span>
          </div>

          <table class="min-w-full mt-2">
            <tr>
              <th>
                <span class="flex items-center mr-4">
                  <div class="w-3 h-3 mr-1 rounded-full ${palette.visitorsLegendClass}"></div>
                  <span>
                    ${dataIndex == 0 ? "Entered the funnel" : "Visitors"}
                  </span>
                </span>
              </th>
              <td class="text-right font-bold px-4">
                <span>
                  ${dataIndex == 0 ? funnel.total.toLocaleString() : currentStep.count.toLocaleString()}
                </span>
              </td>
              <td class="text-right text-sm">
                <span>
                  ${dataIndex == 0 ? funnel.total : currentStep.conversion_rate_step}%
                </span>
              </td>
            </tr>
            <tr>
              <th>
                <span class="flex items-center">
                  <div class="w-3 h-3 mr-1 rounded-full ${palette.dropoffLegendClass}"></div>
                  <span>
                    ${dataIndex == 0 ? "Never entered the funnel" : "Dropoff"}
                  </span>
                </span>
              </th>
              <td class="text-right font-bold px-4">
                <span>???</span>
              </td >
              <td class="text-right text-sm">
                <span>???%</span>
              </td>
            </tr >
          </table >
        </aside >
      `
        }
        tooltipEl.style.display = null
    }
}

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
        const createDiagonalPattern = (color1, color2) => {
            // create a 10x10 px canvas for the pattern's base shape
            let shape = document.createElement('canvas')
            shape.width = 10
            shape.height = 10
            let c = shape.getContext('2d')

            c.fillStyle = color1
            c.strokeStyle = color2
            c.fillRect(0, 0, shape.width, shape.height);

            c.beginPath()
            c.moveTo(2, 0)
            c.lineTo(10, 8)
            c.stroke()

            c.beginPath()
            c.moveTo(0, 8)
            c.lineTo(2, 10)
            c.stroke()

            return c.createPattern(shape, 'repeat')
        }

        const palette = getPalette()

        const formatDataLabel = (visitors, ctx) => {
            if (ctx.dataset.label === 'Visitors') {
                const conversionRate = funnel.steps[ctx.dataIndex].conversion_rate || "100"
                return `${conversionRate}% \n(${numberFormatter(visitors)} Visitors)`
            } else {
                return null
            }
        }
        var fontFamily = 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"'
        const ctx = this.element.getContext("2d");
        const calcBarThickness = (ctx) => {
            if (ctx.dataset.data.length <= 3) {
                return 160
            } else {
                return Math.floor(650 / ctx.dataset.data.length)
            }
        }

        var gradient = ctx.createLinearGradient(900, 0, 900, 900);
        gradient.addColorStop(1, palette.dropoffBackground);
        gradient.addColorStop(0, palette.visitorsBackground);
        const labels = funnel.steps.map((step) => step.step)
        const stepData = funnel.steps.map((step) => step.count)
        const dropOffData = funnel.steps.map((step) => step.dropoff)

        const data = {
            labels: labels,
            datasets: [
                {
                    label: 'Visitors',
                    data: stepData,
                    backgroundColor: gradient,
                    hoverBackgroundColor: gradient,
                    borderRadius: 4,
                    stack: 'Stack 0',
                },
                {
                    label: 'Dropoff',
                    data: dropOffData,
                    backgroundColor: createDiagonalPattern(palette.dropoffBackground, palette.dropoffStripes),
                    hoverBackgroundColor: palette.dropoffBackground,
                    borderRadius: 4,
                    stack: 'Stack 0',
                },
            ],
        }

        console.log(data)
        const config = {
            plugins: [ChartDataLabels],
            type: 'bar',
            data: data,
            options: {
                responsive: true,
                barThickness: calcBarThickness,
                plugins: {
                    legend: {
                        display: false,
                    },
                    tooltip: {
                        enabled: false,
                        mode: 'index',
                        intersect: true,
                        position: 'average',
                        external: FunnelTooltip(palette, funnel)
                    },
                    datalabels: {
                        formatter: formatDataLabel,
                        anchor: 'end',
                        align: 'end',
                        offset: 8,
                        backgroundColor: 'rgba(25, 30, 56, 0.97)',
                        color: 'rgb(243, 244, 246)',
                        borderRadius: 4,
                        clip: true,
                        font: { size: 12, weight: 'normal', lineHeight: 1.6, family: fontFamily },
                        textAlign: 'center',
                        padding: { top: 8, bottom: 8, right: 8, left: 8 },
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
