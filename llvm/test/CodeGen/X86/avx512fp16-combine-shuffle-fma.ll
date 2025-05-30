; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=f16c,fma | FileCheck %s --check-prefix=F16C
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512vl | FileCheck %s --check-prefix=F16C
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512fp16,avx512vl | FileCheck %s --check-prefix=FP16

define <2 x half> @foo(<2 x half> %0) "unsafe-fp-math"="true" nounwind {
; AVX2-LABEL: foo:
; AVX2:       # %bb.0:
; AVX2-NEXT:    subq $40, %rsp
; AVX2-NEXT:    vmovdqa %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; AVX2-NEXT:    vpsrld $16, %xmm0, %xmm0
; AVX2-NEXT:    callq __extendhfsf2@PLT
; AVX2-NEXT:    vmulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    callq __truncsfhf2@PLT
; AVX2-NEXT:    vmovss %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; AVX2-NEXT:    vmovaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; AVX2-NEXT:    callq __extendhfsf2@PLT
; AVX2-NEXT:    vmovss %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 4-byte Spill
; AVX2-NEXT:    vmovss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 4-byte Reload
; AVX2-NEXT:    # xmm0 = mem[0],zero,zero,zero
; AVX2-NEXT:    callq __extendhfsf2@PLT
; AVX2-NEXT:    vsubss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0, %xmm0 # 4-byte Folded Reload
; AVX2-NEXT:    callq __truncsfhf2@PLT
; AVX2-NEXT:    addq $40, %rsp
; AVX2-NEXT:    retq
;
; F16C-LABEL: foo:
; F16C:       # %bb.0:
; F16C-NEXT:    vpsrld $16, %xmm0, %xmm1
; F16C-NEXT:    vcvtph2ps %xmm1, %ymm1
; F16C-NEXT:    vmulps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; F16C-NEXT:    vcvtps2ph $4, %ymm1, %xmm1
; F16C-NEXT:    vcvtph2ps %xmm0, %ymm0
; F16C-NEXT:    vcvtph2ps %xmm1, %ymm1
; F16C-NEXT:    vsubps %ymm0, %ymm1, %ymm2
; F16C-NEXT:    vcvtps2ph $4, %ymm2, %xmm2
; F16C-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; F16C-NEXT:    vcvtps2ph $4, %ymm0, %xmm0
; F16C-NEXT:    vpblendw {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2,3,4,5,6,7]
; F16C-NEXT:    vzeroupper
; F16C-NEXT:    retq
;
; FP16-LABEL: foo:
; FP16:       # %bb.0:
; FP16-NEXT:    vpsrld $16, %xmm0, %xmm1
; FP16-NEXT:    vfmaddsub231ph {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; FP16-NEXT:    retq
  %2 = shufflevector <2 x half> %0, <2 x half> undef, <2 x i32> <i32 1, i32 2>
  %3 = fmul fast <2 x half> %2, <half 0xH3D3A, half 0xH3854>
  %4 = fsub fast <2 x half> %3, %0
  %5 = fadd fast <2 x half> %3, %0
  %6 = shufflevector <2 x half> %4, <2 x half> %5, <2 x i32> <i32 0, i32 3>
  %7 = fadd fast <2 x half> %6, zeroinitializer
  %8 = shufflevector <2 x half> undef, <2 x half> %7, <2 x i32> <i32 0, i32 3>
  %9 = fsub fast <2 x half> %8, zeroinitializer
  ret <2 x half> %9
}
