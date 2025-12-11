/**
 * Converts a UTC datetime string to the user's local timezone
 * @param {string} utcDateTimeString - ISO format datetime string (e.g., "2025-12-10T14:30:00")
 * @returns {string} - Formatted local datetime string
 */
export function formatLocalDateTime(utcDateTimeString) {
  if (!utcDateTimeString) return ''
  
  const date = new Date(utcDateTimeString)
  return date.toLocaleString()
}

/**
 * Converts a UTC datetime string to the user's local timezone for datetime-local input
 * @param {string} utcDateTimeString - ISO format datetime string
 * @returns {string} - Format suitable for datetime-local input (YYYY-MM-DDTHH:mm)
 */
export function formatLocalDateTimeForInput(utcDateTimeString) {
  if (!utcDateTimeString) return ''
  
  const date = new Date(utcDateTimeString)
  
  // Get local date/time components
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  
  return `${year}-${month}-${day}T${hours}:${minutes}`
}

/**
 * Converts a UTC datetime string to display format with timezone abbreviation
 * @param {string} utcDateTimeString - ISO format datetime string
 * @returns {string} - Formatted datetime with timezone (e.g., "12/10/2025, 2:30:00 PM EST")
 */
export function formatLocalDateTimeWithTimezone(utcDateTimeString) {
  if (!utcDateTimeString) return ''
  
  const date = new Date(utcDateTimeString)
  
  // Format with timezone info
  const formatter = new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: true,
    timeZoneName: 'short',
  })
  
  return formatter.format(date)
}
