using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Type;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class TypeController : ControllerBase
    {
        private readonly ITypeService _typeService;

        public TypeController(ITypeService typeService)
        {
            _typeService = typeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _typeService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Type list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _typeService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Type not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Type details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(TypeRequest request)
        {
            var result = await _typeService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Type saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, TypeRequest request)
        {
            var result = await _typeService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Type not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Type updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _typeService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Type not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Type deleted successfully."
            ));
        }
    }
}
