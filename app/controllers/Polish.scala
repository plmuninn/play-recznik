package controllers

import play.api._
import play.api.mvc._
import akka.pattern.ask
import shared.{RequestWord, FindPolishTranslation, SortPolishList, PolishFirstLetter}
import database.ServiceError
import tables.{SerbianWord, PolishWord}
import play.api.libs.json._
import play.api.libs.functional.syntax._
import scala.concurrent.Future

/**
 * @author loki
 */
object Polish extends MainController {

  implicit val wordFormat = Json.format[RequestWord]
  implicit val polishFormat = Json.format[PolishWord]
  implicit val serbianFormat = Json.format[SerbianWord]

  def find = Action.async(parse.json) {
    implicit request =>
      val json = request.body
      json.validate[RequestWord].fold(
        valid = {
          form =>
            globalActor.ask(PolishFirstLetter(form.word)).mapTo[Either[ServiceError, List[PolishWord]]].map({
              case Left(ko) => NotFound
              case Right(ok) => Ok(JsArray(ok.map(word => Json.toJson(word))))
            })
        },
        invalid = {
          errors =>
            Future.successful(NotFound)
        }
      )
  }

  def translate = Action.async(parse.json) {
    implicit request =>
      val json = request.body
      json.validate[RequestWord].fold(
        valid = {
          form =>
            globalActor.ask(FindPolishTranslation(form.id, form.word)).mapTo[Either[ServiceError, List[SerbianWord]]].map({
              case Left(ko) => NotFound
              case Right(ok) => Ok(JsArray(ok.map(word => Json.toJson(word))))
            })
        },
        invalid = {
          errors =>
            Future.successful(NotFound)
        }
      )

  }

  /*  def sort(word: String) = Action.async {
      globalActor.ask(SortPolishList(word)).mapTo[Either[ServiceError, List[PolishWord]]].map({
        case Left(ko) => NotFound
        case Right(ok) => Ok(JsArray(ok.map(word => Json.toJson(word))))
      })
    }*/
}
