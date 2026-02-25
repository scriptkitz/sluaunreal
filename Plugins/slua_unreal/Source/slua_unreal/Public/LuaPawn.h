#pragma once

#include "CoreMinimal.h"
#include "LuaNetSerialization.h"
#include "LuaOverriderInterface.h"
#include "GameFramework/Pawn.h"
#include "LuaPawn.generated.h"

UCLASS(BlueprintType, Blueprintable)
class SLUA_UNREAL_API ALuaPawn : public APawn, public ILuaOverriderInterface
{
    GENERATED_UCLASS_BODY()

public:
    virtual void PostInitializeComponents() override;
    void PostLuaHook() override
    {
    }

    virtual FString GetLuaFilePath_Implementation() const override;

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
};
