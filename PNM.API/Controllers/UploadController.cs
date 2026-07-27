using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace PNM.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    [Route("api/[controller]")]
    public class UploadController : ControllerBase
    {
        private readonly IWebHostEnvironment _env;

        public UploadController(IWebHostEnvironment env)
        {
            _env = env;
        }

        /// <summary>
        /// Upload an operator profile photo.
        /// Returns the relative URL path: /uploads/operators/filename.ext
        /// </summary>
        [HttpPost("operator-photo")]
        public async Task<IActionResult> UploadOperatorPhoto(IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest(new { success = false, message = "No file provided." });

            // Validate file type
            var allowedTypes = new[] { "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp" };
            if (!allowedTypes.Contains(file.ContentType.ToLower()))
                return BadRequest(new { success = false, message = "Only image files are allowed (jpg, png, gif, webp)." });

            // Max 5MB
            if (file.Length > 5 * 1024 * 1024)
                return BadRequest(new { success = false, message = "File size must be under 5MB." });

            var uploadFolder = Path.Combine(_env.WebRootPath, "uploads", "operators");
            Directory.CreateDirectory(uploadFolder);

            // Build unique filename: timestamp + original extension
            var ext      = Path.GetExtension(file.FileName).ToLower();
            var fileName = $"{DateTime.Now:yyyyMMdd_HHmmss}_{Guid.NewGuid().ToString("N")[..6]}{ext}";
            var filePath = Path.Combine(uploadFolder, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            var relativePath = $"/uploads/operators/{fileName}";
            return Ok(new { success = true, path = relativePath });
        }
    }
}
