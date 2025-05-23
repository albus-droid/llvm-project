; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals all --version 5
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -passes=amdgpu-sw-lower-lds < %s | FileCheck %s
@lds = external addrspace(3) global [5 x i8], align 8
declare void @non_kernel_declaration() sanitize_address

;.
; CHECK: @llvm.amdgcn.sw.lds.k1 = internal addrspace(3) global ptr poison, no_sanitize_address, align 8, !absolute_symbol [[META0:![0-9]+]]
; CHECK: @llvm.amdgcn.sw.lds.k1.md = internal addrspace(1) global %llvm.amdgcn.sw.lds.k1.md.type { %llvm.amdgcn.sw.lds.k1.md.item { i32 0, i32 8, i32 32 }, %llvm.amdgcn.sw.lds.k1.md.item { i32 32, i32 5, i32 32 } }, no_sanitize_address
; @llvm.amdgcn.sw.lds.base.table = internal addrspace(1) constant [1 x ptr addrspace(3)] [ptr addrspace(3) @llvm.amdgcn.sw.lds.k1], no_sanitize_address
; @llvm.amdgcn.sw.lds.offset.table = internal addrspace(1) constant [1 x [1 x ptr addrspace(1)]] [[1 x ptr addrspace(1)] [ptr addrspace(1) getelementptr inbounds (%llvm.amdgcn.sw.lds.k1.md.type, ptr addrspace(1) @llvm.amdgcn.sw.lds.k1.md, i32 0, i32 1, i32 0)]], no_sanitize_address
;.
define void @non_kernel_function() sanitize_address {
; CHECK-LABEL: define void @non_kernel_function(
; CHECK-SAME: ) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.amdgcn.lds.kernel.id()
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [1 x ptr addrspace(3)], ptr addrspace(1) @llvm.amdgcn.sw.lds.base.table, i32 0, i32 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = load ptr addrspace(3), ptr addrspace(1) [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load ptr addrspace(1), ptr addrspace(3) [[TMP3]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [1 x [1 x ptr addrspace(1)]], ptr addrspace(1) @llvm.amdgcn.sw.lds.offset.table, i32 0, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = load ptr addrspace(1), ptr addrspace(1) [[TMP5]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr addrspace(1) [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i8, ptr addrspace(3) [[TMP3]], i32 [[TMP7]]
; CHECK-NEXT:    [[TMP14:%.*]] = ptrtoint ptr addrspace(3) [[TMP8]] to i32
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i8, ptr addrspace(1) [[TMP4]], i32 [[TMP14]]
; CHECK-NEXT:    [[TMP11:%.*]] = addrspacecast ptr addrspace(1) [[TMP10]] to ptr
; CHECK-NEXT:    [[TMP12:%.*]] = ptrtoint ptr addrspace(3) [[TMP8]] to i32
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i8, ptr addrspace(1) [[TMP4]], i32 [[TMP12]]
; CHECK-NEXT:    [[TMP9:%.*]] = addrspacecast ptr addrspace(1) [[TMP13]] to ptr
; CHECK-NEXT:    store i8 5, ptr [[TMP9]], align 8
; CHECK-NEXT:    ret void
;
  %Y = addrspacecast ptr addrspace(3) @lds to ptr
  store i8 5, ptr addrspacecast( ptr addrspace(3) @lds to ptr), align 8
  ret void
}

define amdgpu_kernel void @k1() sanitize_address {
; CHECK-LABEL: define amdgpu_kernel void @k1(
; CHECK-SAME: ) #[[ATTR1:[0-9]+]] !llvm.amdgcn.lds.kernel.id [[META2:![0-9]+]] {
; CHECK-NEXT:  [[WID:.*]]:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = or i32 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i32 [[TMP4]], 0
; CHECK-NEXT:    br i1 [[TMP5]], label %[[MALLOC:.*]], label %[[BB18:.*]]
; CHECK:       [[MALLOC]]:
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr addrspace(1) getelementptr inbounds ([[LLVM_AMDGCN_SW_LDS_K1_MD_TYPE:%.*]], ptr addrspace(1) @llvm.amdgcn.sw.lds.k1.md, i32 0, i32 1, i32 0), align 4
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr addrspace(1) getelementptr inbounds ([[LLVM_AMDGCN_SW_LDS_K1_MD_TYPE]], ptr addrspace(1) @llvm.amdgcn.sw.lds.k1.md, i32 0, i32 1, i32 2), align 4
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 [[TMP6]], [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = zext i32 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = call ptr @llvm.returnaddress(i32 0)
; CHECK-NEXT:    [[TMP11:%.*]] = ptrtoint ptr [[TMP10]] to i64
; CHECK-NEXT:    [[TMP12:%.*]] = call i64 @__asan_malloc_impl(i64 [[TMP9]], i64 [[TMP11]])
; CHECK-NEXT:    [[TMP13:%.*]] = inttoptr i64 [[TMP12]] to ptr addrspace(1)
; CHECK-NEXT:    store ptr addrspace(1) [[TMP13]], ptr addrspace(3) @llvm.amdgcn.sw.lds.k1, align 8
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i8, ptr addrspace(1) [[TMP13]], i64 8
; CHECK-NEXT:    [[TMP15:%.*]] = ptrtoint ptr addrspace(1) [[TMP14]] to i64
; CHECK-NEXT:    call void @__asan_poison_region(i64 [[TMP15]], i64 24)
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds i8, ptr addrspace(1) [[TMP13]], i64 37
; CHECK-NEXT:    [[TMP17:%.*]] = ptrtoint ptr addrspace(1) [[TMP16]] to i64
; CHECK-NEXT:    call void @__asan_poison_region(i64 [[TMP17]], i64 27)
; CHECK-NEXT:    br label %[[BB18]]
; CHECK:       [[BB18]]:
; CHECK-NEXT:    [[XYZCOND:%.*]] = phi i1 [ false, %[[WID]] ], [ true, %[[MALLOC]] ]
; CHECK-NEXT:    call void @llvm.amdgcn.s.barrier()
; CHECK-NEXT:    [[TMP19:%.*]] = load ptr addrspace(1), ptr addrspace(3) @llvm.amdgcn.sw.lds.k1, align 8
; CHECK-NEXT:    call void @non_kernel_function()
; CHECK-NEXT:    call void @non_kernel_declaration()
; CHECK-NEXT:    br label %[[CONDFREE:.*]]
; CHECK:       [[CONDFREE]]:
; CHECK-NEXT:    call void @llvm.amdgcn.s.barrier()
; CHECK-NEXT:    br i1 [[XYZCOND]], label %[[FREE:.*]], label %[[END:.*]]
; CHECK:       [[FREE]]:
; CHECK-NEXT:    [[TMP20:%.*]] = call ptr @llvm.returnaddress(i32 0)
; CHECK-NEXT:    [[TMP21:%.*]] = ptrtoint ptr [[TMP20]] to i64
; CHECK-NEXT:    [[TMP22:%.*]] = ptrtoint ptr addrspace(1) [[TMP19]] to i64
; CHECK-NEXT:    call void @__asan_free_impl(i64 [[TMP22]], i64 [[TMP21]])
; CHECK-NEXT:    br label %[[END]]
; CHECK:       [[END]]:
; CHECK-NEXT:    ret void
;
  call void @non_kernel_function()
  call void @non_kernel_declaration()
  ret void
}

!llvm.module.flags = !{!0}
!0 = !{i32 4, !"nosanitize_address", i32 1}
;.
; CHECK: attributes #[[ATTR0]] = { sanitize_address }
; CHECK: attributes #[[ATTR1]] = { sanitize_address "amdgpu-lds-size"="8" }
; CHECK: attributes #[[ATTR2:[0-9]+]] = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
; CHECK: attributes #[[ATTR3:[0-9]+]] = { nocallback nofree nosync nounwind willreturn memory(none) }
; CHECK: attributes #[[ATTR4:[0-9]+]] = { convergent nocallback nofree nounwind willreturn }
;.
; CHECK: [[META0]] = !{i32 0, i32 1}
; CHECK: [[META1:![0-9]+]] = !{i32 4, !"nosanitize_address", i32 1}
; CHECK: [[META2]] = !{i32 0}
;.
