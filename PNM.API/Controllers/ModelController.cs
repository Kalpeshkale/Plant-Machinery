using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Model;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ModelController : ControllerBase
    {
        private readonly IModelService _modelService;

        public ModelController(IModelService modelService)
        {
            _modelService = modelService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _modelService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Model list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _modelService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Model not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Model details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ModelRequest request)
        {
            var result = await _modelService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Model saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ModelRequest request)
        {
            var result = await _modelService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Model not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Model updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _modelService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Model not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Model deleted successfully."
            ));
        }
    }
}
