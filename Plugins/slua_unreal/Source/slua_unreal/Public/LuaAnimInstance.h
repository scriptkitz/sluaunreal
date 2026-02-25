#pragma once

#include "CoreMinimal.h"
#include "LuaNetSerialization.h"
#include "LuaOverriderInterface.h"
#include "GameFramework/Actor.h"

#include "LuaAnimInstance.generated.h"

UCLASS(BlueprintType, Blueprintable)
class SLUA_UNREAL_API ULuaAnimInstance : public UAnimInstance, public ILuaOverriderInterface
{
    GENERATED_UCLASS_BODY()

public:
    virtual FString GetLuaFilePath_Implementation() const override;

    UFUNCTION(Blueprintcallable)
    void RegistLuaTick(float TickInterval);

    UFUNCTION(Blueprintcallable)
    void UnRegistLuaTick();

    virtual void GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const override;

    UPROPERTY(Replicated)
        FLuaNetSerialization LuaNetSerialization;

    UFUNCTION(BlueprintCallable, Category = "slua", meta = (DeprecatedFunction, DeprecationMessage = "Instead of using overload blueprint functions."))
    FLuaBPVar CallLuaMember(FString FunctionName, const TArray<FLuaBPVar>& Args) {
        return CallLuaFunction(FunctionName, Args);
    }

protected:
    UPROPERTY(BlueprintReadOnly, EditAnywhere, Category = "slua")
        FString LuaFilePath;

private:
    bool EnableLuaTick = false;
};
