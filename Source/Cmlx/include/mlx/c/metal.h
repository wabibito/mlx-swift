/* Copyright © 2023-2024 Apple Inc.                   */
/*                                                    */
/* This file is auto-generated. Do not edit manually. */
/*                                                    */

#ifndef MLX_METAL_H
#define MLX_METAL_H

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include "mlx/c/array.h"
#include "mlx/c/closure.h"
#include "mlx/c/distributed_group.h"
#include "mlx/c/io_types.h"
#include "mlx/c/map.h"
#include "mlx/c/stream.h"
#include "mlx/c/string.h"
#include "mlx/c/vector.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * \defgroup metal Metal specific operations
 */
/**@{*/

int mlx_metal_is_available(bool* res);
int mlx_metal_start_capture(const char* path);
int mlx_metal_stop_capture(void);

/* Background-execution gate (Onyx fork) — see mlx/backend/metal/metal.h. */
int mlx_metal_set_background_execution_suspended(bool suspended);
int mlx_metal_background_execution_suspended(bool* res);
int mlx_metal_background_execution_failed(bool reset, bool* res);
int mlx_metal_wait_for_gpu_idle(int timeout_ms, bool* idle);
int mlx_metal_is_background_revocation_error(
    const char* description,
    long code,
    bool* res);

/**@}*/

#ifdef __cplusplus
}
#endif

#endif
