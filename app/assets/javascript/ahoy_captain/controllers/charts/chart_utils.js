export const getCSS = (varname, alpha = 1) => {
  const value = getComputedStyle(document.documentElement).getPropertyValue(varname);
  if(value.includes("em") || value.includes("px")) {
    return value
  }
  return `hsl(${getComputedStyle(document.documentElement).getPropertyValue(varname)} / ${alpha})`
}
const calculatePercentageDifference = function(oldValue, newValue) {
  if(!oldValue) { return false }
  if (oldValue == 0 && newValue > 0) {
    return 100
  } else if (oldValue == 0 && newValue == 0) {
    return 0
  } else {
    return Math.round((newValue - oldValue) / oldValue * 100)
  }
}

const buildTooltipData = (controller, tooltip) => {
  const data = controller.chart.config.data.datasets.find((set) => set.yAxisID == "y")
  const comparisonData = controller.chart.config.data.datasets.find((set) => set.yAxisID == "yComparison");
  const dataIndex = controller.chart.config.data.datasets.indexOf(data)
  const comparisonDataIndex = controller.chart.config.data.datasets.indexOf(comparisonData);

  const tooltipData = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == dataIndex)
  const tooltipComparisonData = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == comparisonDataIndex);
  const label = data.label[tooltipData.dataIndex];
  let comparisonLabel = false
  let comparisonValue = false
  if(comparisonData) {
    comparisonLabel = comparisonData.label[tooltipComparisonData.dataIndex];
    comparisonValue = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == comparisonDataIndex)?.raw || 0
  }

  const value = tooltip.dataPoints.find((dataPoint) => dataPoint.datasetIndex == dataIndex)?.raw || 0

  return {
    comparisonDifference: calculatePercentageDifference(comparisonValue, value),
    metric: controller.labelValue,
    label: label,
    formattedValue: value,
    comparisonLabel: comparisonLabel,
    formattedComparisonValue: comparisonValue
  }
}
export const externalTooltipHandler = (controller) => {

  return ({chart, tooltip}) => {
    const offset = controller.chart.canvas.getBoundingClientRect()
    let tooltipEl = document.getElementById('chartjs-tooltip')

    if (!tooltipEl) {
      tooltipEl = document.createElement('div')
      tooltipEl.id = 'chartjs-tooltip'
      tooltipEl.style.background = getCSS('--n', );
      tooltipEl.style.borderRadius = getCSS('--rounded-btn');
      tooltipEl.style.opacity = 1;
      tooltipEl.style.pointerEvents = 'none';
      tooltipEl.style.position = 'absolute';
      tooltipEl.style.transform = 'translate(-50%, 50%)';
      tooltipEl.style.transition = 'all .1s ease';

      chart.canvas.parentNode.appendChild(tooltipEl);
    }

    if (tooltipEl && offset && window.innerWidth < 768) {
      tooltipEl.style.top = offset.y + offset.height + window.scrollY + 15 + 'px'
      tooltipEl.style.left = offset.x + 'px'
      tooltipEl.style.right = null
      tooltipEl.style.opacity = 1
    }

    if (tooltip.opacity === 0) {
      tooltipEl.style.display = 'none'
      return
    }

    if (tooltip.body) {
      const tooltipData = buildTooltipData(controller, tooltip)

      tooltipEl.innerHTML = `
        <aside class="flex flex-col text-neutral-content">
          <div class="flex justify-between items-center">
            <span class="text-sm font-bold uppercase whitespace-nowrap flex mr-4">${tooltipData.metric}</span>
            ${tooltipData.comparisonDifference ?
        `<div class="inline-flex items-center space-x-1">
              ${tooltipData.comparisonDifference > 0 ? `<span class="font-semibold text-sm text-green-500">&uarr;</span><span>${tooltipData.comparisonDifference}%</span>` : ""}
              ${tooltipData.comparisonDifference < 0 ? `<span class="font-semibold text-sm text-red-400">&darr;</span><span>${tooltipData.comparisonDifference * -1}%</span>` : ""}
              ${tooltipData.comparisonDifference == 0 ? `<span class="font-semibold text-sm">〰 0%</span>` : ""}
            </div>` : ''}
          </div>

          ${tooltipData.label ?
        `<div class="flex flex-col">
            <div class="flex flex-row justify-between items-center">
              <span class="flex items-center mr-4">
                <span>${tooltipData.label}</span>
              </span>
              <span class="font-bold">${tooltipData.formattedValue}</span>
            </div>` : ''}

            ${tooltipData.comparisonLabel ?
        `<div class="flex flex-row justify-between items-center">
              <span class="flex items-center mr-4">
                <span>${tooltipData.comparisonLabel}</span>
              </span>
              <span class="font-bold">${tooltipData.formattedComparisonValue}</span>
            </div>` : ""}
          </div>
        </aside>
      `
    }
    const {offsetLeft: positionX, offsetTop: positionY} = chart.canvas;

    // Display, position, and set styles for font
    tooltipEl.style.opacity = 1;
    tooltipEl.style.display = null;
    tooltipEl.style.left = positionX + tooltip._eventPosition.x + 'px';
    tooltipEl.style.top = positionY + tooltip._eventPosition.y + 'px';
    tooltipEl.style.font = tooltip.options.bodyFont.string;
    tooltipEl.style.padding = tooltip.options.padding + 'px ' + tooltip.options.padding + 'px';
  }
};