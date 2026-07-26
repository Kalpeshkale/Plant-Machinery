using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Make;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class MakeController : ControllerBase
    {
        private readonly IMakeService _makeService;

        public MakeController(IMakeService makeService)
        {
            _makeService = makeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _makeService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Make list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _makeService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Make not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Make details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(MakeRequest request)
        {
            var result = await _makeService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Make saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, MakeRequest request)
        {
            var result = await _makeService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Make not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Make updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _makeService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Make not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Make deleted successfully."
            ));
        }
    }
}
