using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.User;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _userService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "User list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _userService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("User not found."));
            return Ok(ApiResponseHelper.Success(
                data, "User details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(UserRequest request)
        {
            var result = await _userService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "User saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, UserRequest request)
        {
            var result = await _userService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("User not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "User updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _userService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("User not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "User deleted successfully."
            ));
        }
    }
}
