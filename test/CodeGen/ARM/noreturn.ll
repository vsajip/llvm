; RUN: llc -O3 -o - %s | FileCheck %s
; Test case from PR16882.
target triple = "thumbv7s-apple-ios"

; Function Attrs: noreturn
define i32 @test1() #0 {
; CHECK-LABEL: @test1
; CHECK-NOT: push
entry:
  tail call void @overflow() #0
  unreachable
}

; Function Attrs: noreturn
declare void @overflow() #0

define i32 @test2(i32 %x, i32 %y) {
; CHECK-LABEL: @test2
; CHECK-NOT: push
; CHECK-NOT: pop
entry:
  %conv = sext i32 %x to i64
  %conv1 = sext i32 %y to i64
  %mul = mul nsw i64 %conv1, %conv
  %conv2 = trunc i64 %mul to i32
  %conv3 = sext i32 %conv2 to i64
  %cmp = icmp eq i64 %mul, %conv3
  br i1 %cmp, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  tail call void @overflow() #0
  unreachable

if.end:                                           ; preds = %entry
  ret i32 %conv2
}

attributes #0 = { noreturn }
